class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #
  # acts_as_paranoid
  acts_as_mappable :default_units => :kms,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude

  # validate :check_stylist
  # def check_stylist
  #     if account_type == "stylist"
  #         errors.add(:latitude, "can't be blank when Account Type is Stylist")  if latitude.blank?
  #         errors.add(:longitude, "can't be blank when Account Type is Stylist") if longitude.blank?
  #     end      
  # end
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  belongs_to :salon
  belongs_to :brand
  has_many :orders
  has_many :authentications, dependent: :destroy
  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :following, through: :following_relationships, source: :following

  has_many :blocker_relationships, foreign_key: :blocking_id, class_name: 'Block', dependent: :destroy
  has_many :blocker, through: :blocker_relationships, source: :blocker
  has_many :blocked_relationships, foreign_key: :blocker_id, class_name: 'Block', dependent: :destroy
  has_many :blocking, through: :blocked_relationships, source: :blocking

  has_many :contacts, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :folios, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :offerings, dependent: :destroy
  has_many :services, through: :offerings
  has_many :posts, -> { order(created_at: :desc) } ,dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :push_notifications, dependent: :destroy
  has_many :delivery_orders, class_name: 'Order', foreign_key: :delivery_user_id, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_one :primary_card, -> { where(is_primary: true) }, class_name: 'Card'
  has_many :referrer_coupons, class_name: 'Coupon', foreign_key: :referrer_id, dependent: :destroy
  has_many :referent_coupons, class_name: 'Coupon', foreign_key: :referent_id, dependent: :nullify
  has_many :blocking_posts, through: :blocking, source: :posts

  has_many :delivery_orders, class_name: 'Order', foreign_key: :delivery_user_id, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :wallet_commission_lists, dependent: :destroy


  has_and_belongs_to_many :experiences
  has_and_belongs_to_many :certificates


  accepts_nested_attributes_for :salon, allow_destroy: true
  accepts_nested_attributes_for :brand, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :offerings, allow_destroy: true

  enum account_type: [:consumer, :stylist, :ambassador, :owner, :delivery, :warehouse] 

  before_create :generate_authentication_token!
  before_save :create_referral_code

  before_validation :set_default_account_type

  after_create :follow_autofollows
  after_create :create_wallet!

  default_scope { includes(:likes, :favourites, :offerings, :certificates, :educations, :experiences) }

  scope :search, -> (query) {
    includes(:salon, :brand, :services, :experiences)
      .where('(users.first_name ilike ?) or (users.last_name ilike ?) or (users.description ilike ?) or (salons.name ilike ?) or (brands.name ilike ?) or (services.name ilike ?) or (experiences.name ilike ?)', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
      .references(:salon)
  }

  scope :profile_search, ->(query) {
    left_joins(:salon, :brand, :services, :experiences)
      .where('(users.first_name ilike :query) or (users.last_name ilike :query) or (users.description ilike :query) or (salons.name ilike :query) or (brands.name ilike :query) or (services.name ilike :query) or (experiences.name ilike :query)', query: "%#{query}%")
  }

  def unread_messages_count
    Conversation.participant(self).map {|c| c.messages.where(read: false).where('user_id != ?', self.id).length }.sum
  end

  def follow_autofollows
    User.where(auto_follow: true).each do |user|
      Follow.create(follower: self, following: user)
    end
  end

  def friends
    following & followers
  end

  def following?(user)
    self.following.include?(user)
  end

  def followers?(user)
    self.followers.include?(user)
  end

  def set_default_account_type
    self.account_type ||= 'consumer'
  end

  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def self.validate_facebook_token(token)
    Koala::Facebook::API.new(token).get_object('me?fields=id,name,first_name,last_name,email,friends')
  rescue
    false
  end

  def generate_social_authentication!(name, token, secret=nil, uid_name=nil)
    Authentication.create_with(user: self, token: token, secret: secret, facebook_id: uid_name, provider: Provider.find_by(name: name)).find_or_create_by(user: self, provider: Provider.find_by(name: name))
  end

  def self.validate_instagram_token(token)
    Instagram.client(access_token: token).user
  rescue
    false
  end

  def self.create_from_social(response)
    password = Devise.friendly_token
    name = response['full_name'] ? response['full_name'] : response['name']
    user = create(email: response['email'] ? response['email'] : "socialemail#{rand(0..83293)}@example.com", first_name: name.split(' ').first, last_name: name.split(' ').last, password: password, password_confirmation: password) rescue User.new
    return user.valid? ? user : false
  end

  def title
    if consumer? || stylist? || delivery? || warehouse?
      "#{first_name} #{last_name}"
    elsif ambassador?
      brand&.name
    elsif owner?
      salon&.name
    else
      ''
    end
    # "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_referral_code
    return if referral_code.present?

    code =
      loop do
        referral_code = SecureRandom.hex[0, 6].upcase&.to_s
        break referral_code unless User.where(referral_code: referral_code).first
      end
    self.referral_code = code
  end

  # def active_for_authentication?
  #   super && !deleted_at
  # end
end

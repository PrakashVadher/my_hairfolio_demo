class Post < ApplicationRecord
  # mount_uploader :image, AttachmentUploader
  belongs_to :user  
  has_and_belongs_to_many :products 
  
  has_and_belongs_to_many :contacts
  validates_presence_of :user, :description
  has_and_belongs_to_many :folios, -> { distinct }
  
  has_many :likes, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true

  default_scope { includes(:likes, :videos, :comments, photos: {labels: [:tag, :formulas]}, user: [:followers, :following, :likes, :offerings, :certificates, :educations, :experiences]) }

  scope :popular, -> { where('created_at > ?', 7.days.ago).order('likes_count desc') }
  scope :favorites, -> (user) { where(id: user.likes.pluck(:post_id)) }
  scope :by_tag, -> (tag_ids) { joins(photos: :tags).where(tags: { id: tag_ids } ) }
  scope :homepage_post, -> { includes(:photos,:user)}

  def rails_admin_title
    "<a href='#{post_image_home_page}'>Link</a>".html_safe
  end

  def post_image
    photos&.first&.asset_url
  end

  def post_image_home_page
    if photos&.first&.asset_url?
        photos&.first&.asset_url
    else
      "#"
    end
    ##link_to(image_tag(photos&.first&.post_id, :alt =>  "alt text", :class =>"anyclass"), photos&.first&.asset_url)
  end


  def self.post_details
    post_list = Post.unscoped.homepage_post.order("created_at desc") #Post.joins(:photos).select('posts.id,posts.user_id,photos.id,photos.asset_url').limit(5)
  end

end

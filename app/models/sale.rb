class Sale < ApplicationRecord
  mount_uploader :image, AttachmentUploader

  has_many :items, dependent: :destroy
  has_many :products, through: :items
  validates_presence_of :start_date, :end_date, :image, :discount_percentage
  validates_datetime :start_date, after: Time.now.utc, on: :create
  validates_datetime :end_date, after: :start_date
  validate :sale_exist, on: :create
  validates :discount_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  validate :check_image

  def check_image   
  return if self.image.path.exclude? "tmp" 
    image = MiniMagick::Image.open(self.image.path)    
    unless image[:width] >= 1717 && image[:height] >= 558
      errors.add :image, "should be 1717x558px minimum!" 
    end
  end

  def self.add_for_new
    if Sale.count > 0
      'Sale'
    else
      nil
    end
  end

  def sale_exist
    errors.add(:base, 'You can not add more than one sale.') unless Sale.count.zero?
  end

  def active
    (start_date < Time.now.utc) && (end_date > Time.now.utc)
  end
end

class Tag < ApplicationRecord
  validates_presence_of :name
  has_many :labels
  has_many :photos, through: :labels
  has_many :products

  before_save :parameterize_name
  scope :popular, -> { order('labels_count desc').where('labels_count > 0') }
  scope :popular_today, -> { joins(:labels).order('tags.labels_count desc').where("labels.created_at >= ? and labels.created_at <= ?", Time.now - 24.hours, Time.now) }
  scope :popular_last_48_hours, -> { joins(:labels).order('tags.labels_count desc').where("labels.created_at >= ? and labels.created_at <= ?", Time.now - 48.hours, Time.now) }
  scope :popular_last_7_days, -> { joins(:labels).order('tags.labels_count desc').where("labels.created_at >= ? and labels.created_at <= ?", Time.now - 7.days, Time.now) }
  scope :popular_last_30_days, -> { joins(:labels).order('tags.labels_count desc').where("labels.created_at >= ? and labels.created_at <= ?", Time.now - 30.days, Time.now) }

  def parameterize_name
    self.name = self.name.parameterize
  end

  class << self
    def search(term)
      where('name ILIKE ?', "%#{term}")
    end
  end
end

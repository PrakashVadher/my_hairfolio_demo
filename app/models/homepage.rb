class Homepage < ApplicationRecord

	#default_scope :order => 'likes_count '
	has_many :homepagepost
	has_many :posts,-> { order(likes_count: :desc) }, through: :homepagepost
	
	enum status: [:active, :inactive]
	#scope :popular, -> { order('labels_count desc').where('labels_count > 0') }

	validates :title_heading, presence: true, uniqueness: true
	validates_presence_of :post_ids, :if => lambda { |o| o.title_heading != '' }
	#validates :posts, :presence => true
	validates_presence_of :status

	#validate :check_record, on: :create

	def check_record
		errors.add(:base, "You can't create more than two") if Homepage.second.present? 
	end

	def self.get_post
		self.posts.pluck :id
	end
end

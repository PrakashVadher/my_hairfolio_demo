class ContactSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :first_name, :last_name, :company, :address, :city, :state, :country_code, :zipcode, :asset_url, :posts
  has_many :emails
  has_many :phones

  def posts
    object.posts.map { |p| PostSerializer.new(p).serializable_hash }
  end
end

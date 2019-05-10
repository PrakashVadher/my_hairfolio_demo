class VideoSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :asset_url, :video_url, :created_at

end

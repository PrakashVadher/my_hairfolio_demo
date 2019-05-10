class PostsQuery
  attr_accessor :scope
  def initialize(scope = Post.all)
    @scope = scope
  end

  def by_tags(tag_ids)
    scope.joins(photos: :tags).where(tags: { id: tag_ids })
  end

  def related_tags
    Post.where(posts: { id: scope}).joins(photos: :labels).select('labels.tag_id')
  end

  def related_posts
    Post.by_tag(related_tags)
  end
end
class TagsQuery
  attr_accessor :scope
  def initialize(scope = Tags.all)
    @scope = scope
  end

  def related_tags
    posts = Post.by_tag(scope.ids)
    posts.joins(photos: :tags).select('tags.id')
  end
end
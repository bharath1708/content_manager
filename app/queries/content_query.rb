class ContentQuery
  FILTERS = {
    platform: :by_platform,
    content_type: :by_content_type,
    status: :by_status,
    category_id: :by_category,
    tag_id: :by_tag,
    tag: :tagged_with
  }.freeze

  def initialize(params, relation: Content.all)
    @params = params
    @relation = relation
  end

  def call
    result = @relation.includes(:category, :tags)

    FILTERS.each do |param, scope|
      value = @params[param]
      result = result.public_send(scope, value) if value.present?
    end

    result.order(created_at: :desc)
  end
end

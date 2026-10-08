module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 50

  private

  def paginate(relation)
    page     = [ params.fetch(:page, 1).to_i, 1 ].max
    per_page = params.fetch(:per_page, DEFAULT_PER_PAGE).to_i.clamp(1, MAX_PER_PAGE)
    total    = relation.count

    records = relation.limit(per_page).offset((page - 1) * per_page)
    meta = {
      page: page,
      per_page: per_page,
      total: total,
      total_pages: (total.to_f / per_page).ceil
    }

    [ records, meta ]
  end
end

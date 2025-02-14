module PaginationConcern
  extend ActiveSupport::Concern
  def pagination_details(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
      total_pages: collection.total_pages,
      current_count: collection.length,
      total_count: collection.total_count # use collection.total_entries when using will_paginate
    } if collection.present?
  end
end
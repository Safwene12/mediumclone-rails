#Here we made necessary implementation for pagination
module Paginable
  extend ActiveSupport::Concern

  def paginate(collection)
    paginator.call(
      collection,
      params: { number: params[:offset], size: params[:limit] },
      base_url: request.url,
    )
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_param
    params.permit![:page]
  end

  def render_collection(paginated)
    options = {
      meta: paginated.meta.to_h,
      links: paginated.links.to_h,
    }

    result = { articlesCount: options[:meta][:total], articles: collection_serializer.new(paginated.items, scope: @user) }
    render json: result, status: :ok
  end
end

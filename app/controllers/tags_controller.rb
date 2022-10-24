class TagsController < ApplicationController
  skip_before_action :authorized, only: [:index]

  def index
    tags = Tag.all
    if !tags
      return render json: { error: { tags: ["Error while get tags"] } }, status: :not_found
    end
    render json: { tags: tags.map(&:name) }
  end
end

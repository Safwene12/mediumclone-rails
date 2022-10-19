class ArticlesController < ApplicationController

  #Post /api/articles
  def create
    tag_ids = Tag.ids_from_names(article_params[:article][:tags])
    article = @user.articles.create(article_params[:article].except("tags"))
    tags = article.article_tags.insert_all(tag_ids)

    puts article.save
    if @article
      render json: { article: @article }, status: :created
    else
      render json: { error: @article.errors }, status: :unprocessable_entity
    end
  end

  #Put /api/articles
  def update
    @article = @user.articles.find_by_slug(article_update_params[:slug]).update(article_update_params)
    render json: { article: @article }, status: :created
  end

  private

  def article_params
    params.permit(article: [:body, :description, :title, :tags => []])
  end

  def article_update_params
    params.require(:article)
  end
end

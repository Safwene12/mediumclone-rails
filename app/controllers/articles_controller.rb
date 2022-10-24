class ArticlesController < ApplicationController
  include Paginable

  before_action :set_article, only: [:update, :destroy]

  skip_before_action :authorized, only: [:index, :show]

  # GET /api/articles
  def index
    articles = Article.recent
    if params[:tag].present?
      articles = articles.filter_by_tag_name params[:tag]
    end
    if params[:author].present?
      articles = articles.by_author params[:author]
    end
    paginated = paginate(articles)
    render_collection(paginated)
  end

  def show
    article = Article.where(slug: params[:id]).first
    if article
      render json: { article: serializer.new(article) }, status: :ok
    else
      render json: { error: { article: ["Not found"] } }, status: :not_found
    end
  end

  #Post /api/articles
  def create
    tag_ids = Tag.ids_from_names(article_params[:article][:tagList])
    puts tag_ids
    #tag_ids returns error if something is wrong while tags creation or selection
    if tag_ids.class == ActiveModel::Errors
      return render json: { errors: tag_ids }, status: :unprocessable_entity
    end

    article = @user.articles.create(article_params[:article].except("tagList"))
    if !article.save
      return render json: { errors: article.errors }, status: :unprocessable_entity
    end
    tags = article.article_tags.insert_all(tag_ids)

    render json: { article: serializer.new(article) }, status: :created
  end

  #Put /api/articles
  def update
    tag_ids = Tag.ids_from_names(article_update_params[:article][:tagList])
    Article.update_tags(@article, tag_ids)
    article = @article.update(article_update_params[:article].except("tagList"))
    render json: { article: serializer.new(@article.reload) }, status: :ok
  rescue
    render json: { error: { article: ["Error while updating"] } }, status: :not_found
  end

  #DELETE /api/articles/:slug
  def destroy
    @article.destroy()
    render json: { message: "Article deleted successfully" }, status: :ok
  rescue
    render json: { error: { article: ["Error while deleting"] } }, status: :not_found
  end

  private

  def article_params
    params.permit(article: [:body, :description, :title, :tagList => []])
  end

  def article_update_params
    params.permit(article: [:body, :description, :title, :tagList => []])
  end

  def set_article
    @article = @user.articles.where(slug: params[:id]).first
    if !@article
      return render json: { error: { article: ["Article not found or you are unauthorized to update it"] } }
    end
  end

  def serializer
    ArticleSerializer
  end

  def collection_serializer
    ArticleSerializer::CollectionSerializer
  end
end

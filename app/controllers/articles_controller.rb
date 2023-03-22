class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer

    
    # cookies[:cookies_page_views] ||=0
    # render json: {session: session, cookies: cookies.to_hash}

  end

  def show
    session[:page_views] ||=0
    session[:page_views] += 1

    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: {error: "You have reached the maximum number of article views."}, status: :unauthorized
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end



end

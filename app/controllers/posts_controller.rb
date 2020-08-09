require 'jekyll_github_pages'

class PostsController < ApplicationController
  def initialize
    @post_service = Services::PostService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN']))
    @post_factory = Factories::PostFactory.new
  end

  # GET /posts
  def index
    render json: {
        'existingPosts': @post_service.get_all_posts,
        'prPosts': @post_service.get_all_posts_in_pr(Rails.configuration.post_pr_body)
    }
  end

  # POST /posts
  def create
    formatted_post_text = @post_factory.create_jekyll_post_text(params[:text], params[:author], params[:title])
    @post_factory.create_post(formatted_post_text, params[:title], Rails.configuration.post_pr_body)
    render json: { 'success': true }
  end

  # PUT /posts
  def edit
    formatted_post_text = @post_factory.create_jekyll_post_text(params[:text], params[:author], params[:title])
    @post_service.edit_post(formatted_post_text, params[:title], params[:path], Rails.configuration.post_pr_body) if !params[:ref]
    @post_service.edit_post_in_pr(formatted_post_text, params[:title], params[:path], params[:ref]) if params[:ref]
    render json: { 'success': true}
  end
end

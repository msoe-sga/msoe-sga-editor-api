require 'jekyll_github_pages'

class PostsController < ApplicationController
  def initialize
    @post_service = Services::PostService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN'])
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
    if !params[:text] || params[:text].empty?
      render json: { 'error': 'Cannot create a post that is empty.' }, status: 400
    elsif !params[:author]
      render json: { 'error': 'A author is required to create a post.' }, status: 400
    elsif !params[:title]
      render json: { 'error': 'A title is required to create a post.' }, status: 400
    else
      formatted_post_text = @post_factory.create_jekyll_post_text(params[:text], params[:author], params[:title])
      @post_service.create_post(formatted_post_text, params[:title], Rails.configuration.post_pr_body)
      render json: { 'success': true }
    end
  end

  # PUT /posts
  def edit
    if !params[:text] || params[:text].empty?
      render json: { 'error': 'Cannot edit a post to be empty.' }, status: 400
    elsif !params[:author]
      render json: { 'error': 'A author is required to edit a post.' }, status: 400
    elsif !params[:title]
      render json: { 'error': 'A title is required to edit a post.' }, status: 400
    elsif !params[:path]
      render json: { 'error': 'The post path is required to edit a post.' }, status: 400
    else
      formatted_post_text = @post_factory.create_jekyll_post_text(params[:text], params[:author], params[:title])
      @post_service.edit_post(formatted_post_text, params[:title], params[:path], Rails.configuration.post_pr_body) if !params[:ref]
      @post_service.edit_post_in_pr(formatted_post_text, params[:title], params[:path], params[:ref]) if params[:ref]
      render json: { 'success': true}
    end
  end
end

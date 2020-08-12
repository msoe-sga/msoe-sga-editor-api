require 'jekyll_github_pages'

class AboutController < ApplicationController
  def initialize
    @page_service = Services::PageService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN'])
    @page_factory = Factories::PageFactory.new
  end

  # GET /about
  def index
    render json: @page_service.get_markdown_page(Rails.configuration.about_page_file_path, Rails.configuration.about_page_pr_body)
  end

  # PUT /about
  def edit
    if !params[:text] || params[:text].empty?
      render json: { 'error': 'The about page cannot be edited to have no text.' }, status: 400
    else
      formatted_page_contents = @page_factory.create_jekyll_page_text(params[:text], Rails.configuration.about_page_title, 
                                                                      Rails.configuration.about_permalink)
      result = @page_service.save_page_update(Rails.configuration.about_page_file_path, Rails.configuration.about_page_title, 
      formatted_page_contents, params[:ref], Rails.configuration.about_page_pr_body)
      render json: result
    end
  end
end

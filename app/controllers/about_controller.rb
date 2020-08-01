require 'jekyll_github_pages'

class AboutController < ApplicationController
  def initialize
    @page_service = Services::PageService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN'])
  end

  # GET /about
  def index
    render json: @page_service.get_markdown_page(Rails.configuration.about_page_file_path, Rails.configuration.about_page_pr_body)
  end

  # PUT /about
  def edit
    @page_service.save_page_update(Rails.configuration.about_page_file_path, Rails.configuration.about_page_title, 
                                   params[:ref], Rails.configuration.about_page_pr_body)
    render json: { 'success': true }
  end
end

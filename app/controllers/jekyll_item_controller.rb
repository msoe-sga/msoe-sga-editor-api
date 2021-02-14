require 'jekyll_github_pages'

class JekyllItemController < ApplicationController
  # GET /items
  def items
    if !params[:type]
      render_type_not_specified_error
    else
      item_information = get_item_information(params[:type].to_sym)
      item_service = item_information[:item_service]
      if params[:collection_name]
        pr_items = item_service.get_all_jekyll_items_in_collection_and_in_pr(params[:collection_name], item_information[:pr_body])
        default_branch_items = item_service.get_all_jekyll_items_in_collection_from_default_branch(params[:collection_name], pr_items)
        render json: { 'prItems': pr_items, 'defaultBranchItems': default_branch_items }, status: 200
      elsif params[:file_path]
        render json: item_service.get_jekyll_item(params[:file_path], item_information[:pr_body]), status: 200
      else
        render json: { 'error': 'The jekyll collection name or item file path is not specified.'}, status: 400
      end
    end
  end
  
  # Note this is a POST because otherwise the text can truncate with a GET leaving us with
  # an incomplete preview
  # POST /items/preview
  def preview
    render json: {
        'result': Services::JekyllItemService.get_preview(params[:text])
    }
  end

  # POST /items
  def create
    if !params[:type]
      render_type_not_specified_error
    else
      item_information = get_item_information(params[:type].to_sym)
      markdown = item_information[:factory].create_jekyll_item_text(params[:properties])
      item_information[:item_service].create_jekyll_item(markdown, params[:properties][:title], item_information[:class], 
                                                         params[:collection_name], item_information[:pr_body], [])
      render json: { 'success': true }
    end
  end
  
  # PUT /items
  def edit
    if !params[:type]
      render_type_not_specified_error
    else
      item_information = get_item_information(params[:type].to_sym)
      markdown = item_information[:factory].create_jekyll_item_text(params[:properties])
      result = item_information[:item_service].save_jekyll_item_update(params[:properties][:file_path], params[:properties][:title], markdown, 
                                                                       item_information[:class], params[:ref], item_information[:pr_body], [])
      render json: result
    end
  end
  
  # DELETE /items
  def delete
  end

  private
  
  def render_type_not_specified_error
    render json: { 'error': 'The jekyll item type is not specified.' }, status: 400
  end

  def get_item_information(type_symbol)
    pr_body = Rails.configuration.pr_body_format % type_symbol.to_s
    case type_symbol
    when :page, :resource
      page_factory = Factories::PageFactory.new
      page_item_service = Services::JekyllItemService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN'], page_factory)
      return { factory: page_factory, class: Page, item_service: page_item_service, pr_body: pr_body}
    when :post
      post_factory = Factories::PostFactory.new
      post_item_service = Services::JekyllItemService.new(Rails.configuration.repo_name, ENV['GITHUB_ACCESS_TOKEN'], post_factory)
      return { factory: post_factory, class: Post, item_service: post_item_service, pr_body: pr_body }
    else
      raise ArgumentError.new "Unrecognized item type #{type_symbol}"
    end
  end
end

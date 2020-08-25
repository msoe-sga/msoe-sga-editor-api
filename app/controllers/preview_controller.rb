require 'jekyll_github_pages'

class PreviewController < ApplicationController
  def initialize
    @kramdown_service = Services::KramdownService.new
  end

  # Note this is a POST because otherwise the text can truncate with a GET leaving us with
  # an incomplete preview
  # POST /preview
  def preview
    render json: {
        'result': @kramdown_service.get_preview(params[:text])
    }
  end
end

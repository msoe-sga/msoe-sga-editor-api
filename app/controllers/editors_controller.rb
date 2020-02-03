class EditorsController < ApplicationController
  # GET /editors
  def index
    render json: Editors.all
  end
  
  # GET /editors/<email>
  def get_by_email
  end

  # POST /editors
  def create
  end

  # PUT /editors
  def edit 
  end
end

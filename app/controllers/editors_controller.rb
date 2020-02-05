class EditorsController < ApplicationController
  # GET /editors
  def index
    # TODO: Add a page size based on what the GUI looks like
    render json: Editors.all(sort: { 'Name': 'asc'})
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

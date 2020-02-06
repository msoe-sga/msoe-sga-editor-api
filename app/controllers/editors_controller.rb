class EditorsController < ApplicationController
  # GET /editors
  def index
    # TODO: Add a page size based on what the GUI looks like
    render json: Editors.all(sort: { 'Name': 'asc'})
  end
  
  # GET /editors/email
  def get_by_email
    render json: Editors.find_by_email(params[:email])
  end

  # POST /editors
  def create
    if params[:name] && params[:email]
      new_editor = Editors.create('Name': params[:name], 'Email': params[:email])
      render json: new_editor 
    elsif !params[:name]
      render json: { 'error': 'A name is required to create an editor.' }
    else
      render json: { 'error': 'A email is required to create an editor.'}
    end
  end

  # PUT /editors
  def edit 
    editor = Editors.find(params[:id])
    editor['Name'] = params[:name] if params[:name]
    editor['Email'] = params[:email] if params[:email]
    editor.save
    render json: editor
  end
end

class EditorsController < ApplicationController
  # GET /editors
  def index
    begin
      # TODO: Add a page size based on what the GUI looks like
      render json: Editors.all(sort: { 'Name': 'asc'})
    rescue Airrecord::Error => e
      render json: { 'error': e.message }, status: 500
    end
  end
  
  # GET /editors/email
  def get_by_email
    begin
      render json: Editors.find_by_email(params[:email])
    rescue Airrecord::Error => e
      render json: { 'error': e.message }, status: 500
    end
  end

  # POST /editors
  def create
    if params[:name] && params[:email]
      begin
        new_editor = Editors.create('Name': params[:name], 'Email': params[:email])
        render json: new_editor 
      rescue Airrecord::Error => e
        render json: { 'error': e.message }, status: 500
      end
    elsif !params[:name]
      render json: { 'error': 'A name is required to create an editor.' }, status: 400
    else
      render json: { 'error': 'A email is required to create an editor.'}, status: 400
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

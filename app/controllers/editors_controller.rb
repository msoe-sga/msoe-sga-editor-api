class EditorsController < ApplicationController
  # GET /editors
  def index
    render json: Editors.all(sort: { 'Name': 'asc' }).select { |editor| editor['Email'] != @email }
  end

  # POST /editors
  def create
    if params[:name] && params[:email]
      find_by_email_result = Editors.find_by_email(params[:email])
      if find_by_email_result.length > 0
        render json: { 'error': "An editor already exists with the email #{params[:email]}" }, status: 400
      else
        new_editor = Editors.create('Name': params[:name], 'Email': params[:email])
        render json: new_editor
      end
    elsif !params[:name] && params[:email]
      render json: { 'error': 'A name is required to create an editor.' }, status: 400
    elsif !params[:email] && params[:name]
      render json: { 'error': 'A email is required to create an editor.' }, status: 400
    else
      render json: { 'error': 'A name and an email is required to create an editor.' }, status: 400
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

  # DELETE /editors
  def delete
    editor = Editors.find(params[:id])
    editor.destroy
    render json: { 'success': true }
  end
end

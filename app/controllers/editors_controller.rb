class EditorsController < ApplicationController
  # GET /editors
  def index
    # TODO: Add a page size based on what the GUI looks like
    render json: Editors.all(sort: { 'Name': 'asc' })
    rescue Airrecord::Error => e
      render json: { 'error': e.message }, status: 500
  end
  
  # GET /editors/email
  def get_by_email
    find_by_email_result = Editors.find_by_email(params[:email])
    if find_by_email_result.length == 0
      render json: { 'error': "No editor exists with the email #{params[:email]}" }, status: 400
    else
      render json: find_by_email_result.first
    end
    rescue Airrecord::Error => e
      render json: { 'error': e.message }, status: 500
  end

  # POST /editors
  def create
    if params[:name] && params[:email]
      find_by_email_result = Editors.find_by_email(params[:email])
      if find_by_email_result.length > 0
        render json: { 'error': "An editor already exists with the email #{params[:email]}" }, status: 400
      else
        begin
          new_editor = Editors.create('Name': params[:name], 'Email': params[:email])
          render json: new_editor 
        rescue Airrecord::Error => e
          render json: { 'error': e.message }, status: 500
        end
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
    if editor
      editor['Name'] = params[:name] if params[:name]
      editor['Email'] = params[:email] if params[:email]
      editor.save
      render json: editor
    else
      render json: { 'error': "No editor exists with the id #{params[:id]}" }
    end
    rescue Airrecord::Error => e 
      render json: { 'error': e.message }, status: 500
  end

  # DELETE /editors
  def delete
    editor = Editors.find(params[:id])
    if editor
      editor.destory
      render json: { 'success': true }
    else
      render json: { 'success': false }
    end
    rescue Airrecord::Error => e
      render json: { 'error': e.message }, status: 500
  end
end

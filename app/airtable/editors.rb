Airrecord.api_key = ENV['AIRTABLE_API_KEY']

class Editors < Airrecord::Table
  self.base_key = Rails.configuration.airtable_editor_base_id
  self.table_name = Rails.configuration.airtable_editors_table_name

  def self.find_by_email(email)
    all(filter: "{Email} = \"#{email}\"")
  end
end

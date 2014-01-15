require 'yaml'
require 'rubygems'
require 'bundler/setup'

Bundler.require

linkedin_options = YAML::load_file( File.join( File.dirname(__FILE__), 'linkedin_options.yml' ) )

client = LinkedIn::Client.new(linkedin_options['linkedin_api_key'], linkedin_options['linkedin_api_secret'])
client.authorize_from_access(linkedin_options['oauth_key'], linkedin_options['oauth_secret'])


workbook = Roo::Spreadsheet.open("./profiles.xlsx")

workbook.default_sheet = workbook.sheets.first

2.upto(workbook.last_row).each do |row_id|
  name = workbook.cell(row_id, 'A')
  profile_url = workbook.cell(row_id, 'B')
  job_title = workbook.cell(row_id, 'C')

  current_profile = client.profile(url: profile_url, fields: [ :headline ] )

  if current_profile.headline.strip != job_title
    puts "\n#{name} has changed jobs."
    puts "\tFormerly: #{job_title}"
    puts "\t New Job: #{current_profile.headline}"
  end
end

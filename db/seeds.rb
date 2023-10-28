# frozen_string_literal: true

require_relative "../app/services/prompts_importer"

begin
  download_pages = ENV.fetch("PROMPTS_DOWNLOAD_PAGES")&.to_i
  PromptsImporter.new(download_pages:).call
  puts "Done!"
rescue => e
  puts e.message
end

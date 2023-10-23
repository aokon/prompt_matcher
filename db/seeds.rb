# frozen_string_literal: true

require_relative "../app/services/prompts_importer"

begin
  PromptsImporter.call
rescue => e
  Rails.logger.error(e.message)
end

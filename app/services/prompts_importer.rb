# frozen_string_literal: true

class PromptsImporter
  PromptDownloadFailed = Class.new(StandardError)
  InvalidPresetsSchema = Class.new(StandardError)

  PRESETS_URL = "datasets-server.huggingface.co/rows?dataset=Gustavosta%2FStable-Diffusion-Prompts&config=default&split=train&offset=0&length=100"

  def self.call
    new.call
  end

  def initialize(model: Prompt)
    @model = model
  end

  def call
    fetch_prompts_presets.then { |response| parse_response(response) }
      .then { |rows| prepare_prompts(rows) }
      .then { |prompts| store_in_db(prompts) }
  end

  private

  attr_reader :model

  def fetch_prompts_presets
    response = Typhoeus.get(PRESETS_URL, followlocation: true)

    raise PromptDownloadFailed, "Something went wrong during fetching data presents" unless response.success?

    response.body
  end

  def parse_response(response)
    json = JSON.parse(response, symbolize_names: true)

    raise InvalidPresetsSchema, "Presets response has invalid schema" unless json.key?(:rows)

    json[:rows]
  end

  def prepare_prompts(rows)
    rows.map do |item|
      content = ActionController::Base.helpers.sanitize(item.dig(:row, :Prompt))
      {content:}
    end
  end

  def store_in_db(prompts)
    model.insert_all(prompts)
  end
end

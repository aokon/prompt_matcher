# frozen_string_literal: true

class PromptsImporter
  PromptDownloadFailed = Class.new(StandardError)
  InvalidPresetsSchema = Class.new(StandardError)
  DEFAULT_PAGE_DOWNLOAD = 1

  def initialize(model: Prompt, download_pages: DEFAULT_PAGE_DOWNLOAD)
    @model = model
    @hydra = Typhoeus::Hydra.new
    @download_pages = download_pages || DEFAULT_PAGE_DOWNLOAD
    @signatures = []
  end

  def call
    requests = prepare_requests
    hydra.run
    requests.each do |req|
      if req.response.success?
        process_response(req.response.body)
        next
      end

      raise PromptDownloadFailed, "Something went wrong during fetching data presents"
    end
  end

  private

  attr_reader :model, :hydra, :download_pages, :signatures

  def prepare_requests
    download_pages.times.map do |t|
      url = "datasets-server.huggingface.co/rows?dataset=Gustavosta%2FStable-Diffusion-Prompts&config=default&split=train&offset=#{t}&length=100"
      request = Typhoeus::Request.new(url, followlocation: true)
      hydra.queue(request)
      request
    end
  end

  def process_response(response)
    parse_response(response)
      .then { |rows| prepare_prompts(rows) }
      .then { |prompts| store_in_db(prompts) }
      .then { model.reindex }
  end

  def parse_response(response)
    json = JSON.parse(response, symbolize_names: true)

    raise InvalidPresetsSchema, "Presets response has invalid schema" unless json.key?(:rows)

    json[:rows]
  end

  def prepare_prompts(rows)
    rows.map do |item|
      content = ActionController::Base.helpers.sanitize(item.dig(:row, :Prompt))
      signature = Base64.encode64(content)

      next if signatures.include?(signature)

      signatures.push(signature)
      {content:}
    end.compact
  end

  def store_in_db(prompts)
    model.insert_all(prompts)
  end
end

# frozen_string_literal: true

class PromptsSearch
  ITEMS_PER_PAGE = 10

  def initialize(phrase:, page:, model: Prompt)
    @phrase = phrase
    @model = model
    @page = page
  end

  def call
    model.search(phrase, page:, per_page: ITEMS_PER_PAGE)
  end

  private

  attr_reader :model, :phrase, :page
end

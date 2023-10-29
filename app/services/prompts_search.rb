# frozen_string_literal: true

class PromptsSearch
  def initialize(phrase:, model: Prompt)
    @phrase = phrase
    @model = model
  end

  def call
    model.search(phrase)
  end

  private

  attr_reader :model, :phrase
end

class PromptsController < ApplicationController
  def index
    @prompts = PromptsSearch.new(phrase: params[:q]).call
  end
end

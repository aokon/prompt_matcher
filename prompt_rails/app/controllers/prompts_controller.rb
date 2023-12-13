class PromptsController < ApplicationController
  def index
    @prompts = PromptsSearch.new(phrase: params[:q], page: params[:page]).call
  end
end

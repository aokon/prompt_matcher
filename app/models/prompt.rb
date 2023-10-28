# frozen_string_literal: true

class Prompt < ApplicationRecord
  validates :content, presence: true
  searchkick index_name: -> { "#{name.tableize}-#{Rails.env}" }

  def search_data
    {content: content}
  end
end

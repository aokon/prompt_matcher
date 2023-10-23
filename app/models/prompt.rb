class Prompt < ApplicationRecord
  validates :content, presence: true
end

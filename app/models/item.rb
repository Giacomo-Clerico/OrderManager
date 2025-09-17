class Item < ApplicationRecord
  belongs_to :quote
  belongs_to :product
  validates :price, presence: true

  scope :selected, -> { where(selected: true) }
end

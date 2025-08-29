class Item < ApplicationRecord
  belongs_to :quote
  validates :item_name, :price, presence: true

  scope :selected, -> { where(selected: true) }
end

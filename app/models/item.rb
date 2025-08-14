class Item < ApplicationRecord
  belongs_to :quote
  validates :item_name, :price, presence: true
end

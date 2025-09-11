class Product < ApplicationRecord
  CATEGORIES = %w[consumable spare component]
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :code, presence: true
  has_many :stocks
  has_many :requests
  has_rich_text :desctription
end

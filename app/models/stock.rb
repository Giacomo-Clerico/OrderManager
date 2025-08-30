class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :storage, polymorphic: true

  validates :quantity, presence: true
end

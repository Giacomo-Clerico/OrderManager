class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :storage, polymorphic: true

  validates :quantity, presence: true
  def self.add!(product_id:, storage_id:, storage_type:, quantity:, location:)
    stock = find_or_initialize_by(
      product_id: product_id,
      storage_id: storage_id,
      storage_type: storage_type,
      location: location
    )
    stock.quantity = stock.quantity.to_i + quantity.to_i
    stock.save!
    stock
  end
end

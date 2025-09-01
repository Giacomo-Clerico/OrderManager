class Good < ApplicationRecord
  belongs_to :delivery_note
  belongs_to :product
  belongs_to :storage, polymorphic: true
  validates :quantity, presence: true
end

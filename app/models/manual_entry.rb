class ManualEntry < ApplicationRecord
  belongs_to :product
  belongs_to :storage, polymorphic: true
  belongs_to :user

  validates :quantity, presence: true
  validates :location, presence: true
end

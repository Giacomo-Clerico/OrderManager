class Good < ApplicationRecord
  belongs_to :delivery_note
  validates :description, presence: true
  validates :quantity, presence: true
end

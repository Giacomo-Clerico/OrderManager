class DeliveryNote < ApplicationRecord
  belongs_to :order, class_name: "Order"
  belongs_to :recieved_by, class_name: "User"
  has_many :goods, dependent: :destroy
  has_rich_text :body

  validates :company, presence: true
end

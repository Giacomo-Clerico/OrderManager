class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :paid_by, class_name: "User"
  belongs_to :quote

  has_rich_text :body

  validates :company, presence: true
  validates :bank, presence: true
  validates :account, presence: true
end

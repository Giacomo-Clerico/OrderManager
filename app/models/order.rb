class Order < ApplicationRecord
  belongs_to :user
  belongs_to :checked_by, class_name: "User", optional: true
  has_many :quotes, dependent: :destroy
  has_rich_text :description
  validates :name, presence: true
  validates :description, presence: true
end

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :checked_by, class_name: "User", optional: true
  belongs_to :quotes_submitted_by, class_name: "User", optional: true
  belongs_to :approved_by, class_name: "User", optional: true
  has_many :quotes, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :delivery_notes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_rich_text :description
  validates :name, presence: true
  validates :description, presence: true

  enum :status, %i[requested checked refused quoted approved revised restored denied paid]
end

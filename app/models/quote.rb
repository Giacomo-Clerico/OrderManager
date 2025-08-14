class Quote < ApplicationRecord
  belongs_to :order
  belongs_to :requested_by, class_name: "User"


  has_many :items, dependent: :destroy

  has_rich_text :body

  validate :user_must_have_permission
  validates :company, :company_address, :body, presence: true

  private

  def user_must_have_permission
    unless %w[cashier manager director].include?(requested_by.user_type)
      errors.add(:user, "is not authorized to post a quote")
    end
  end
end

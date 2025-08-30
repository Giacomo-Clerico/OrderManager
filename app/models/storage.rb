class Storage < ApplicationRecord
  validates :name, presence: true
  has_many :stocks
end

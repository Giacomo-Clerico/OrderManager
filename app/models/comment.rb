class Comment < ApplicationRecord
  belongs_to :order
  belongs_to :user, class_name: "User", optional: false
  has_rich_text :body
end

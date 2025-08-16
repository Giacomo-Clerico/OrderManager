class AddRecommendedToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :recommended, :boolean
  end
end

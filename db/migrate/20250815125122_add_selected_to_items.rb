class AddSelectedToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :selected, :boolean
  end
end

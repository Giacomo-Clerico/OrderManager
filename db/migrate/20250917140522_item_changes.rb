class ItemChanges < ActiveRecord::Migration[8.0]
  def change
    remove_column :items, :item_name, :string
    add_reference :items, :product, null: false, foreign_key: true
  end
end

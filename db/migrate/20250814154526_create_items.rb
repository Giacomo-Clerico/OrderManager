class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.references :quote, null: false, foreign_key: true
      t.text :item_name
      t.integer :price

      t.timestamps
    end
  end
end

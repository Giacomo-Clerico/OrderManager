class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.references :storage, null: false, polymorphic: true, index: true
      t.timestamps
    end
  end
end

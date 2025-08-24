class CreateGoods < ActiveRecord::Migration[8.0]
  def change
    create_table :goods do |t|
      t.references :delivery_note, null: false, foreign_key: { to_table: :delivery_notes }
      t.text :description
      t.integer :quantity
      t.string :location
      t.timestamps
    end
  end
end

class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :desctription, null: false
      t.string :category, null: false
      t.string :type
      t.timestamps
    end
  end
end

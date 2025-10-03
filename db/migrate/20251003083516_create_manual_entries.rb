class CreateManualEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :manual_entries do |t|
      t.references :product, null: false, foreign_key: true
      t.references :storage, polymorphic: true, null: false
      t.string :location
      t.integer :quantity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateDeliveryNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_notes do |t|
      t.references :recieved_by, null: false, foreign_key: { to_table: :users }
      t.text :body
      t.timestamps
    end
  end
end

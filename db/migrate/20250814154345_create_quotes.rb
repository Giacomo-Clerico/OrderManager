class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.references :order, null: false, foreign_key: true
      t.text :company
      t.text :company_address
      t.text :body
      t.references :requested_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

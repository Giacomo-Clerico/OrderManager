class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :company
      t.text :body
      t.string :bank
      t.string :account
      t.references :paid_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

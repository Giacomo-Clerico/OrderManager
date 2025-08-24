class AddDetailsToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :amount, :integer
    add_column :payments, :from_account, :text
  end
end

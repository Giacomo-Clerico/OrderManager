class AddCurrencyToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :currency, :string, limit: 3
  end
end

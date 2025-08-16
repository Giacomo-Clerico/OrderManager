class AddCurrencyToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :currency, :string, limit: 3
  end
end

class AddPrefixToQuotes < ActiveRecord::Migration[8.0]
  def change
    add_column :quotes, :buy_as, :string
  end
end

class AddLocationToStocks < ActiveRecord::Migration[8.0]
  def change
    add_column :stocks, :location, :string
  end
end

class ChangeStatusColumnTypeInOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :status, :string
  end
end

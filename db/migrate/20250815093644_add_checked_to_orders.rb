class AddCheckedToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :checked, :boolean,  null: true
  end
end

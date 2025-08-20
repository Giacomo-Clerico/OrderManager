class AddApprovalToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :approved, :string
    add_reference :orders, :approved_by, null: true, foreign_key: { to_table: :users }
    add_column :orders, :approved_timestamp, :timestamp
  end
end

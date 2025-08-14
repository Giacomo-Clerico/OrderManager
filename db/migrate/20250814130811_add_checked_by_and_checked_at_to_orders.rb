class AddCheckedByAndCheckedAtToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :checked_by, null: true, foreign_key: { to_table: :users }
    add_column :orders, :checked_at, :datetime
  end
end

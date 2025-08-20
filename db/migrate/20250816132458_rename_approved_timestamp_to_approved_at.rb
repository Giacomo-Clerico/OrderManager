class RenameApprovedTimestampToApprovedAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :approved_timestamp, :approved_at
  end
end

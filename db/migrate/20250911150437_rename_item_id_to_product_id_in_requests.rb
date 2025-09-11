class RenameItemIdToProductIdInRequests < ActiveRecord::Migration[8.0]
  def change
    rename_column :requests, :item_id, :product_id
  end
end

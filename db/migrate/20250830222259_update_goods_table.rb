class UpdateGoodsTable < ActiveRecord::Migration[8.0]
  def change
  add_column :goods, :product_id, :bigint, null: false  # replaces description
  add_column :goods, :storage_id, :bigint, null: false
  add_column :goods, :storage_type, :string, null: false

  remove_column :goods, :description, :string
  end
end

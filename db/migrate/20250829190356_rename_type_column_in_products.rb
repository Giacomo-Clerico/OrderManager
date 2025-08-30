class RenameTypeColumnInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :type, :product_type
  end
end

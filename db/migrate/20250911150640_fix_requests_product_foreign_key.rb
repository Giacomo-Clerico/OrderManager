class FixRequestsProductForeignKey < ActiveRecord::Migration[8.0]
  def change
    # remove old foreign key pointing to items
    if foreign_key_exists?(:requests, :items)
      remove_foreign_key :requests, :items
    end

    # add correct foreign key pointing to products
    add_foreign_key :requests, :products, column: :product_id
  end
end

class ChangeDesctriptionNullableInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :desctription, true
  end
end

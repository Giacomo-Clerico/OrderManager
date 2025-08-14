class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.text :name
      t.text :description
      t.timestamp :time

      t.timestamps
    end
  end
end

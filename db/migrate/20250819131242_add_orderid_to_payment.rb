class AddOrderidToPayment < ActiveRecord::Migration[8.0]
  def change
    add_reference :payments, :order, null: false, foreign_key: true
  end
end

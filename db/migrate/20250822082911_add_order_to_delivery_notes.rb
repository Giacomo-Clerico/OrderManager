class AddOrderToDeliveryNotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :delivery_notes, :order, null: false, foreign_key: true
  end
end

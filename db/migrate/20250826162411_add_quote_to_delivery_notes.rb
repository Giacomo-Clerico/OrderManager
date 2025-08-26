class AddQuoteToDeliveryNotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :delivery_notes, :quote, null: false, foreign_key: true
  end
end

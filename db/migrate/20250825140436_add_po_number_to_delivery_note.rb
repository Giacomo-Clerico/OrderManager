class AddPoNumberToDeliveryNote < ActiveRecord::Migration[8.0]
  def change
    add_column :delivery_notes, :po_number, :string
  end
end

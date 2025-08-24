class AddCompanyToDeliveryNote < ActiveRecord::Migration[8.0]
  def change
    add_column :delivery_notes, :company, :text
  end
end

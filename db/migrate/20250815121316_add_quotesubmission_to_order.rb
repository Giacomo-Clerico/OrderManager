class AddQuotesubmissionToOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :quotes_submitted_at, :timestamp
  end
end

class ManualEntriesController < ApplicationController
  def new
    @manual_entry = ManualEntry.new
  end

  def create
    @manual_entry = ManualEntry.new(manual_entry_params.merge(user: current_user))
    if @manual_entry.save
      Stock.add!(
        product_id: @manual_entry.product_id,
        storage_id: @manual_entry.storage_id,
        storage_type: @manual_entry.storage_type,
        location: @manual_entry.location,
        quantity: @manual_entry.quantity
      )
      redirect_to products_path, notice: "Manual stock entry created."
    else
      render :new, alert: "Failed to create manual entry."
    end
  end

  private

  def manual_entry_params
    params.require(:manual_entry).permit(:product_id, :storage_id, :storage_type, :location, :quantity)
  end
end

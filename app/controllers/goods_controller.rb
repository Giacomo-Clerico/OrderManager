class GoodsController < ApplicationController
  before_action :set_order
  before_action :set_delivery_note
  before_action :require_manager_or_director, only: [ :destroy ]
  before_action :set_good, only: [ :destroy ]
  def new
    @good = @delivery_note.goods.new
  end

  def create
    @good = @delivery_note.goods.new(good_params)
    if @good.save
      Stock.add!(
        product_id: @good.product_id,
        storage_id: @good.storage_id,
        storage_type: @good.storage_type,
        location: @good.location,
        quantity: @good.quantity
      )
      redirect_to [ @delivery_note.order, @delivery_note ], notice: "Good added and stock updated."
    else
      Rails.logger.error "Failed to save Good: #{@good.errors.full_messages.to_sentence}"
      redirect_to [ @delivery_note.order, @delivery_note ], alert: "Failed to add Good: #{@good.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    # Subtract quantity from stock before destroying
    Stock.add!(
      product_id: @good.product_id,
      storage_id: @good.storage_id,
      storage_type: @good.storage_type,
      location: @good.location,
      quantity: -@good.quantity  # subtract instead of add
    )

    @good.destroy
    redirect_to [ @delivery_note.order, @delivery_note ], notice: "Good deleted and stock updated."
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_delivery_note
    @delivery_note = DeliveryNote.find(params[:delivery_note_id])
  end

  def good_params
    params.require(:good).permit(:quantity, :location, :storage_id, :product_id, :storage_type)
  end
end

def require_manager_or_director
  unless %w[manager director].include?(current_user.user_type)
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end
end

def set_good
  @good = @delivery_note.goods.find(params[:id])
end

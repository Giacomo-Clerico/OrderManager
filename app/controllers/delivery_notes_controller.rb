class DeliveryNotesController < ApplicationController
  before_action :set_order

  def new
    @delivery_note = @order.delivery_notes.new
    @delivery_note.order_id = params[:order_id] if params[:order_id].present?
  end

  def create
    @delivery_note = @order.delivery_notes.new(delivery_note_params)
    @delivery_note.recieved_by = current_user
    if @delivery_note.save
      redirect_to [ @order, @delivery_note ], notice: "GRV created successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @delivery_note = @order.delivery_notes.find(params[:id])
    @goods = @delivery_note.goods
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def delivery_note_params
    params.require(:delivery_note).permit(:order_id, :company, :body)
  end
end

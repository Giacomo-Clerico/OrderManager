class DeliveryNotesController < ApplicationController
  before_action :set_order

  def find_order
  end

  def check_order
    quote = Quote.find_by(po_number: params[:po_number])
    if quote&.order
      redirect_to new_delivery_note_path(order_id: quote.order.id, po_number: quote.po_number)
    else
      flash[:alert] = "No order found for PO number #{params[:po_number]}"
      render :find_order, status: :unprocessable_entity
    end
  end

  def new
    if @order.nil?
      flash[:alert] = "Order not found."
      redirect_to find_order_delivery_notes_path and return
    end


      @delivery_note = DeliveryNote.new(order: @order, po_number: params[:po_number])
  end


  def create
    quote = Quote.find_by(po_number: params[:delivery_note][:po_number])

    unless quote
      flash.now[:alert] = "No quote found with PO number #{params[:delivery_note][:po_number]}"
      @delivery_note = DeliveryNote.new
      render :new, status: :unprocessable_entity and return
    end

    @delivery_note = @order.delivery_notes.new(delivery_note_params)
    @delivery_note.order = quote.order
    @delivery_note.quote = quote
    @delivery_note.recieved_by = current_user

    # Check if there is a quote with this po_number
    # quote = Quote.find_by(po_number: @delivery_note.po_number)
    # unless quote
    #   flash.now[:alert] = "No quote found with PO number #{@delivery_note.po_number}"
    #   render :new, status: :unprocessable_entity and return
    # end

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
    @order = if params[:order_id].present?
      Order.find(params[:order_id])
    elsif params.dig(:delivery_note, :order_id).present?
      Order.find(params[:delivery_note][:order_id])
    end
  end

  def delivery_note_params
    params.require(:delivery_note).permit(:company, :body, :order_id, :po_number)
  end
end

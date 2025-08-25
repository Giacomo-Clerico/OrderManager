class OrdersController < ApplicationController
  def index
    @order = Order.order(:id)
  end
  def show
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def check
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to @order, alert: "You are not authorized for technical approvals"
      return  # important: stop execution
    end

    if @order.update_columns(checked_by_id: current_user.id, checked_at: Time.current, checked: true)
      redirect_to @order, notice: "Order checked successfully"
    else
      redirect_to @order, alert: "Unable to check order"
    end
  end

  def refuse
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to @order, alert: "You are not authorized for technical approvals"
      return  # important: stop execution
    end

    if @order.update_columns(checked_by_id: current_user.id, checked_at: Time.current, checked: false)
      redirect_to @order, notice: "Order refused successfully"
    else
      redirect_to @order, alert: "Unable to refuse order"
    end
  end

  def submit_quote
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director", "procurement" ])
      redirect_to @order, alert: "You are not authorized for submitting quotes"
      return  # important: stop execution
    end

    if @order.checked_by.nil?
      redirect_to @order, alert: "The order must be checked before submitting quotes"
      return  # important: stop execution
    end

    if @order.quotes.empty?
      redirect_to @order, alert: "No quotes available to submit"
      return # important: stop execution
    end

    unless @order.quotes_submitted_by.nil?
      redirect_to @order, alert: "Quotes already submitted for this order"
      return  # important: stop execution
    end

    # Validation: must have at least one item
    unless @order.quotes.joins(:items).any?
      redirect_to @order, alert: "You cannot submit without at least an item"
      return
    end

    if @order.update_columns(quotes_submitted_at: Time.current, quotes_submitted_by_id: current_user.id)
      redirect_to @order, notice: "Quotes submitted successfully"
    else
      redirect_to @order, alert: "Unable to submit quotes"
    end
  end

  def approve
    @order = Order.find(params[:id])

    # authorization
    unless current_user.user_type.in?([ "director" ])
      redirect_to @order, alert: "You are not authorized for approving orders"
      return  # important: stop execution
    end

    # Validation: must have at least one selected item
    unless @order.quotes.joins(:items).where(items: { selected: true }).exists?
      redirect_to @order, alert: "You cannot approve an order with no selected items"
      return
    end

    assign_po_numbers(@order)
    if @order.update_columns(approved_by_id: current_user.id, approved_at: Time.current, approved: "approved")
      redirect_to @order, notice: "Order approved successfully"
    else
      redirect_to @order, alert: "Unable to approve order"
    end
  end

  def deny
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "director" ])
      redirect_to @order, alert: "You are not authorized for denying orders"
      return  # important: stop execution
    end

    if @order.update_columns(approved_by_id: current_user.id, approved_at: Time.current, approved: "denied")
      redirect_to @order, notice: "Order denied successfully"
    else
      redirect_to @order, alert: "Unable to deny order"
    end
  end

  def revise
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "director" ])
      redirect_to @order, alert: "You are not authorized for revising orders"
      return  # important: stop execution
    end

    if @order.update_columns(approved_by_id: current_user.id, approved_at: Time.current, approved: "revised", quotes_submitted_by_id: nil, quotes_submitted_at: nil)
      redirect_to @order, notice: "Order revised successfully"
    else
      redirect_to @order, alert: "Unable to revise order"
    end
  end

  def restore
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "director" ])
      redirect_to @order, alert: "You are not authorized for restoring orders"
      return  # important: stop execution
    end

    if @order.update_columns(approved_by_id: current_user.id, approved_at: Time.current, approved: "revised")
      redirect_to @order, notice: "Order restored successfully"
    else
      redirect_to @order, alert: "Unable to restore order"
    end
  end

  private

    def order_params
      params.require(:order).permit(:name, :description)
    end

    def assign_po_numbers(order)
      current_year_suffix = Time.current.strftime("%y")  # e.g. "25"

      order.quotes.each do |quote|
        # only assign if it has at least one selected item
        next unless quote.items.where(selected: true).exists?

        # only assign if PO number is not already set
        next if quote.po_number.present?

        # find the last PO with the same year prefix
        last_po = Quote.where("po_number LIKE ?", "POMF#{current_year_suffix}%").order(:po_number).last

        last_number = if last_po&.po_number.present?
          last_po.po_number[-4..].to_i  # last 4 digits
        else
          0
        end

        # build new PO
        prefix = quote.buy_as # you can make this dynamic later if needed
        new_po_number = "#{prefix}#{current_year_suffix}#{format("%04d", last_number + 1)}"

        quote.update!(po_number: new_po_number)
      end
    end
end

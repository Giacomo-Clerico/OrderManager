class CommentsController < ApplicationController
  before_action :set_order


  def new
    @comment = Comment.new
  end

  def create
    @comment = @order.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @order, notice: "Comment added successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
  def set_order
    @order = Order.find(params[:order_id])
  end

  def comment_params
    params.require(:comment).permit(:order_id, :body)
  end
end

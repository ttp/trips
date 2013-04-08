class TripCommentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /trip/:trip_id/comments
  def index
    comments = TripComment.with_users(params[:trip_id])

    render json: {comments: comments}
  end

  # POST /trip/:trip_id/comments
  def create
    comment = TripComment.new
    comment.comment = params[:comment]
    comment.trip_id = params[:trip_id]
    comment.user_id = current_user.id

    if comment.save
      render json: comment, status: :created
    else
      render json: comment.errors
    end
  end

  # PUT /trip/:trip_id/comments
  def update
    comment = TripComment.find(params[:id])
    redirect_to root_url if comment.user_id != current_user.id

    comment.comment = params[:comment]
    if comment.save
      render json: comment, status: :updated
    else
      render json: comment.errors
    end
  end

  # DELETE /trip/:trip_id/comments
  def destroy
    comment = TripComment.find(params[:id])
    redirect_to root_url if comment.user_id != current_user.id

    comment.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end

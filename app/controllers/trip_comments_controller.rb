class TripCommentsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  # GET /trip/:trip_id/comments
  def index
    comments = TripComment.with_users_hash(params[:trip_id])

    render json: {comments: comments}
  end

  # POST /trip/:trip_id/comments
  def create
    trip = Trip.find(params[:trip_id])

    comment = TripComment.new
    comment.comment = params[:comment]
    comment.trip_id = params[:trip_id]
    comment.user_id = current_user.id

    if comment.save
      comment_attrs = comment.attributes
      comment_attrs['name'] = current_user.name
      comment_attrs['email'] = current_user.email
      comment_bubble = render_to_string({
        partial: 'trips/comment',
        layout: false,
        locals: {comment: comment_attrs, trip: trip}
      })
      render json: {comment: comment, bubble: comment_bubble}, status: :ok
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /trip/:trip_id/comments
  def update
    comment = TripComment.find(params[:comment_id])
    trip = comment.trip
    if comment.user_id != current_user.id && trip.user_id != current_user.id and
      render json: {error: 'incorrect_comment_owner'}, status: :unprocessable_entity
      return
    end

    comment.comment = params[:comment]
    if comment.save
      render json: {message: safe_textile(comment.comment)}, status: :ok
    else
      render json: comment.errors
    end
  end

  # DELETE /trip/:trip_id/comments
  def destroy
    comment = TripComment.find(params[:comment_id])
    trip = comment.trip
    if comment.user_id != current_user.id && trip.user_id != current_user.id and
      render json: {error: 'incorrect_comment_owner'}, status: :unprocessable_entity
      return
    end

    comment.destroy

    render json: {success: :ok}, status: :ok
  end
end

class CommentsController < ApplicationController
  before_action :set_movie

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @movie, notice: t("comments.created_successfully")
    else
      @comments = @movie.comments.includes(:user).ordered_by_newest
      render "movies/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @movie.comments.find(params[:id])

    # Allow deletion if user is comment owner or movie owner
    if can_delete_comment?(@comment)
      @comment.destroy
      redirect_to @movie, notice: t("comments.deleted_successfully")
    else
      redirect_to @movie, alert: t("comments.not_authorized")
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :commenter_name)
  end

  def can_delete_comment?(comment)
    return false unless user_signed_in?

    comment.user == current_user || @movie.user == current_user
  end
end

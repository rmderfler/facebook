class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!
  def new 
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @user_friendship = current_user.user_friendships.new(friend: @friend)
      #flash[:alert] = "#{@user_friendship}"
    else
      flash[:alert] = "Friend required"
    end
  rescue ActiveRecord::RecordNotFound
    render file: 'public/404', status: :not_found
  end

  def create
    if params[:user_friendship]
      #debugger
      @friend = User.find(user_friendship_params.values).first
      @user_friendship = current_user.user_friendships.new(friend: @friend)
      if @user_friendship.save
        flash[:notice] = "Friendship created."
      else
        flash[:alert] = "There was a problem."
      end
      redirect_to profile_path(@friend)
    else
      flash[:alert] = "Friend is required"
      redirect_to root_path
    end
  end

  def friend_params
      params.require(:friend).permit(:friend_id)
  end

  def user_friendship_params
      params.require(:user_friendship).permit(:friend_id)
  end


end

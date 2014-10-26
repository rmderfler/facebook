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

  def index
    @user_friendships = current_user.user_friendships.includes(:friend).all
  end

  def accept
    @user_friendship = current_user.user_friendships.find(params[:id])
    if @user_friendship.accept!
      flash[:success] = "You are now friends with #{@user_friendship.friend.name}"
    else
      flash[:error] = "That friendship could not be accepted"
    end
    redirect_to user_friendships_path
  end

  def create
    if params[:user_friendship]
      @friend = User.find(user_friendship_params.values).first
      @user_friendship = UserFriendship.request(current_user, @friend)
      if @user_friendship.new_record?
        flash[:alert] = "There was a problem creating that friendship request."
      else
        flash[:notice] = "Friendship request sent."
      end
      redirect_to profile_path(@friend)
    else
      flash[:alert] = "Friend is required"
      redirect_to root_path
    end
  end

  def edit
    @user_friendship = current_user.user_friendships.find(params[:id]).decorate
    @friend = @user_friendship.friend
  end

  def destroy
    @user_friendship = current_user.user_friendships.find(params[:id])
    if @user_friendship.destroy
      flash[:success] = "Friendship destroyed."
    else
      flash[:error] = "There was a problem destroying that friendship."
    end
    redirect_to user_friendships_path
  end

  def friend_params
      params.require(:friend).permit(:friend_id)
  end

  def user_friendship_params
      params.require(:user_friendship).permit(:friend_id, :state, :user_friendship)
  end


end

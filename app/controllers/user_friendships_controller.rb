class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
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
    respond_with @user_friendships
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
      respond_to do |format|
        if @user_friendship.new_record?
          format.html do
            flash[:alert] = "There was a problem creating that friendship request."
            redirect_to profile_path(@friend)
          end
          format.json {render json: @user_friendship.to_json, status: :precondition_failed }
        else
          format.html do
            flash[:notice] = "Friendship request sent."
            redirect_to profile_path(@friend)
          end
          format.json { render json: @user_friendship.to_json }
        end
      end
    else
      flash[:alert] = "Friend is required"
      redirect_to root_path
    end
  end

  def edit
    if params.include?("friend_id")
      @friend = User.find(params[:friend_id])
      #binding.pry
      @user_friendship = current_user.user_friendships.where(friend_id: @friend.id).first.decorate
    else
      #binding.pry
      @user_friendship = UserFriendship.find(params[:id])
    end
    #@friend = UserFriendship.where(name: params[:user_id]).first
    #binding.pry
    #@user_friendship = current_user.user_friendships.where(friend_id: @friend.id).first.decorate
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

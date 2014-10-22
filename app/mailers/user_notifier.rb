class UserNotifier < ActionMailer::Base
  default from: "facebook@example.com"

  def friend_requested(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)
    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
      subject: "#{@user.name} wants to be friends on facebook."
      
  end

  def friend_request_accepted(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @user.email,
      subject: "#{@friend.name} has accepted your friend request."
  end
  
end

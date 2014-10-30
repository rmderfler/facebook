class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  has_many :messages
  has_many :user_friendships
  has_many :friends, -> { where(user_friendships: { state: "accepted"}) }, through: :user_friendships
  has_many :activities
  # has_many :pending_user_friendships, class_name: "UserFriendship",
  #                                     foreign_key: :user_id,
  #                                     conditions: { state: 'pending'}
  has_many :pending_friends, 
              -> { where user_friendships: { state: "pending" } }, 
                 through: :user_friendships,
                 source: :friend

  has_many :pending_friends, through: :pending_user_friendships, source: :friend                                    
  
  has_many :requested_user_friendships, -> { where(user_friendships: { state: "requested"}) }, through: :user_friendships

  has_many :requested_friends, through: :requested_user_friendships, source: :friend
  
  has_many :blocked_user_friendships, -> { where(user_friendships: { state: "blocked"}) }, through: :user_friendships

  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
  
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # def to_param
  #   profile_name
  # end

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

  def create_activity(item, action)
    activity = activities.new
    activity.targetable = item
    activity.action = action
    activity.save
    activity
  end
  
end

# <%= image_tag message.user.gravatar_url %>

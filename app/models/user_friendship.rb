class UserFriendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validates :friend_id, uniqueness: { scope: :user_id }

  after_destroy :destroy_mutual_friendship!

  state_machine :state, initial: :pending do
    after_transition on: :accept, do: [:send_acceptance_email, :accept_mutual_friendship!]
    after_transition on: :block, do: [:block_mutual_friendship!]

    state :requested
    state :blocked

    event :accept do
      transition any => :accepted
    end

    event :block do
      transition any => :blocked
    end
  end

  validate :not_blocked


  def self.request(user1, user2)
    transaction do
      friendship1 = create(user: user1, friend: user2, state: 'pending')
      friendship2 = create(user: user2, friend: user1, state: 'requested')

      friendship1.send_request_email if !friendship1.new_record?
      friendship1
    end
  end

  def send_request_email
    UserNotifier.friend_requested(id).deliver
  end

  def send_acceptance_email
    UserNotifier.friend_request_accepted(id).deliver
  end

  def mutual_friendship
    self.class.where({user_id: friend_id, friend_id: user_id}).first
  end

  def destroy_mutual_friendship!
    mutual_friendship.delete if mutual_friendship
  end

  def accept_mutual_friendship!
    # Grab the mutual_friendship and update the state attribute without calling the state
    # callbacks. We don't want the opposite user to get an email or anything.
    mutual_friendship.update_attribute(:state, 'accepted') if mutual_friendship
  end

  def not_blocked
    if UserFriendship.exists?(user_id: user_id, friend_id: friend_id, state: 'blocked') ||
       UserFriendship.exists?(user_id: friend_id, friend_id: user_id, state: 'blocked')
      errors.add(:base, "The friendship cannot be added.")
    end
  end

  def block_mutual_friendship!
    mutual_friendship.update_attribute(:state, 'blocked') if mutual_friendship
  end
end

class Message < ActiveRecord::Base
  belongs_to :user
  # has_many :documents
  attr_accessible :name, :recipient, :message, :sender_email 

  # accepts_nested_attributes_for :documents
  
  validates :user_id, presence: true
end

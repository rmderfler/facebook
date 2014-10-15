class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

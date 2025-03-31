class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :email, :password, :password_confirmation, presence: { message: "Please enter a value." }
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Email must be written in the correct format ([name]@[mailservice].com)" }
  validates :password, presence: true, length: { minimum: 6, message: "Password must have a minimum of 6 characters." }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :book_lists, dependent: :destroy
end

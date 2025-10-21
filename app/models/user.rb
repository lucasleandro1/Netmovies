class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :movies, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :movie_imports, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true

  # Check if user needs to complete profile
  def needs_profile_completion?
    name.blank?
  end

  # Display name - use name if available, otherwise email prefix
  def display_name
    name.present? ? name : email.split("@").first
  end
end

class Comment < ApplicationRecord
  # Associations
  belongs_to :movie
  belongs_to :user, optional: true

  # Validations
  validates :content, presence: true, length: { minimum: 5, maximum: 1000 }
  validates :commenter_name, presence: true, length: { minimum: 2, maximum: 100 }, if: :anonymous?

  # Scopes
  scope :ordered_by_newest, -> { order(created_at: :desc) }

  # Instance methods
  def anonymous?
    user.nil?
  end

  def commenter_display_name
    if anonymous?
      commenter_name
    else
      user.name.present? ? user.name : user.email.split("@").first
    end
  end
end

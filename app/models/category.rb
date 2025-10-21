class Category < ApplicationRecord
  # Associations
  has_and_belongs_to_many :movies

  # Validations
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 50 }

  # Scopes
  scope :ordered_by_name, -> { order(:name) }

  # Callbacks
  before_save :capitalize_name

  private

  def capitalize_name
    self.name = name.titleize if name.present?
  end
end

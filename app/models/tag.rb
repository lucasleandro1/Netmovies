class Tag < ApplicationRecord
  # Associations
  has_and_belongs_to_many :movies

  # Validations
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 30 }

  # Scopes
  scope :ordered_by_name, -> { order(:name) }

  # Callbacks
  before_save :downcase_name

  private

  def downcase_name
    self.name = name.downcase if name.present?
  end
end

class MovieImport < ApplicationRecord
  # Associations
  belongs_to :user
  has_one_attached :csv_file

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
  validates :processed_count, numericality: { greater_than_or_equal_to: 0 }
  validates :error_count, numericality: { greater_than_or_equal_to: 0 }

  # Enums would be nice here but keeping it simple with string validations

  # Scopes
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: "completed") }
  scope :failed, -> { where(status: "failed") }
  scope :pending, -> { where(status: "pending") }

  # Instance methods
  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def processing?
    status == "processing"
  end

  def pending?
    status == "pending"
  end

  def total_count
    processed_count + error_count
  end
end

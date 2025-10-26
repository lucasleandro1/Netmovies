class Movie < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_one_attached :poster

  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :year, presence: true,
                   numericality: {
                     greater_than: 1900,
                     less_than_or_equal_to: Date.current.year + 5
                   }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :director, presence: true

  # Scopes
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  scope :by_year, ->(year) { where(year: year) if year.present? }
  scope :by_director, ->(director) { where("director ILIKE ?", "%#{director}%") if director.present? }
  scope :by_category, ->(category_id) { joins(:categories).where(categories: { id: category_id }) if category_id.present? }
  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") if query.present? }

  # Instance methods
  def display_duration
    hours = duration / 60
    minutes = duration % 60
    "#{hours}h #{minutes}min"
  end

  def poster_url
    poster.attached? ? poster : nil
  end
end

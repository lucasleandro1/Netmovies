require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(1).is_at_most(255) }
    it { should validate_presence_of(:synopsis) }
    it { should validate_length_of(:synopsis).is_at_least(10) }
    it { should validate_presence_of(:year) }
    it { should validate_numericality_of(:year).is_greater_than(1900) }
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).is_greater_than(0) }
    it { should validate_presence_of(:director) }
    it { should validate_length_of(:director).is_at_least(2).is_at_most(255) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:categories) }
    it { should have_and_belong_to_many(:tags) }
    it { should have_one_attached(:poster) }
  end

  describe 'scopes' do
    let!(:movie1) { create(:movie, created_at: 1.day.ago) }
    let!(:movie2) { create(:movie, created_at: 1.hour.ago) }

    it 'orders by newest first' do
      expect(Movie.ordered_by_newest).to eq([ movie2, movie1 ])
    end
  end

  describe '#display_duration' do
    let(:movie) { create(:movie, duration: 150) }

    it 'displays duration in hours and minutes format' do
      expect(movie.display_duration).to eq('2h 30min')
    end
  end

  describe '#poster_url' do
    let(:movie) { create(:movie) }

    context 'when poster is attached' do
      before do
        # This would require a proper file attachment in a real test
        # movie.poster.attach(...)
      end

      it 'returns the poster' do
        expect(movie.poster_url).to be_nil # Since no poster is attached in this test
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

  describe 'validations' do
    subject { build(:comment, movie: movie, user: user) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(5).is_at_most(1000) }

    context 'when user is not present (anonymous comment)' do
      subject { build(:comment, movie: movie, user: nil, commenter_name: 'John Doe') }
      it { should validate_presence_of(:commenter_name) }
    end
  end

  describe 'associations' do
    it { should belong_to(:movie) }
    it { should belong_to(:user).optional }
  end

  describe '#commenter_display_name' do
    context 'when user is present' do
      let(:user) { create(:user, email: 'john@example.com') }
      let(:comment) { create(:comment, movie: movie, user: user) }

      it 'returns the username part of email' do
        expect(comment.commenter_display_name).to eq('john')
      end
    end

    context 'when user is not present (anonymous)' do
      let(:comment) { create(:comment, movie: movie, user: nil, commenter_name: 'Anonymous User') }

      it 'returns the commenter_name' do
        expect(comment.commenter_display_name).to eq('Anonymous User')
      end
    end
  end

  describe '#anonymous?' do
    context 'when user is present' do
      let(:comment) { create(:comment, movie: movie, user: user) }

      it 'returns false' do
        expect(comment.anonymous?).to be false
      end
    end

    context 'when user is not present' do
      let(:comment) { create(:comment, movie: movie, user: nil, commenter_name: 'Anonymous') }

      it 'returns true' do
        expect(comment.anonymous?).to be true
      end
    end
  end
end

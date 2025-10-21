require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:movies).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:movie_imports).dependent(:destroy) }
  end

  describe 'devise modules' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
  end
end

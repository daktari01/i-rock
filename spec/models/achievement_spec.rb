require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    it 'requires title' do
      achievement = Achievement.new(title: '')
      achievement.valid?
      expect(achievement.errors[:title]).to include("can't be blank")
      expect(achievement.errors[:title]).not_to be_empty
      expect(achievement.valid?).to be_falsey
    end
    
    # Alternative of above example
    it { should validate_presence_of(:title) }

    it 'requires title to be unique for one user' do
      user = FactoryBot.create(:user)
      first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user)
      new_achievement = Achievement.new(title: 'First Achievement', user: user)
      expect(new_achievement.valid?).to be_falsey
    end

    it 'allows different users to have identical titles' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user1)
      new_achievement = Achievement.new(title: 'First Achievement', user: user2)
      expect(new_achievement.valid?).to be_truthy
    end

    # Alternative of the above 2 examples
    it { should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("You can't have two achievements with the same title") }

    it 'belongs to user' do
      achievement = Achievement.new(title: 'Some title', user: nil)
      expect(achievement.valid?).to be_falsey
    end

    # Alternative of above example
    it { should validate_presence_of(:user) }

    it 'has belongs_to user association' do
      #   1st approach
      user = FactoryBot.create(:user)
      achievement = FactoryBot.create(:public_achievement, user: user)
      expect(achievement.user).to eq(user)

      #   2nd approach
      u = Achievement.reflect_on_association(:user)
      expect(u.macro).to eq(:belongs_to)
    end
    # Alternative of above example, but not passing because of [optional: true] on achievement model
    # it { should belong_to(:user) }
  end
end

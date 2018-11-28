class Achievement < ApplicationRecord
  belongs_to :user, optional: true

  validates :title, presence: true
  # validates :title, uniqueness: true
  validates :user, presence: true

  validate :unique_title_for_one_user

  enum privacy: %i[public_access private_access friends_access]

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end

  private

  def unique_title_for_one_user
    existing_achievement = Achievement.find_by(title: title)
    if existing_achievement && existing_achievement.user == user
      errors.add(:title, "You can't have the same achievement with the same title")
    end
  end
end

class Card < ApplicationRecord

  before_save :save_as_primary, unless: :user_has_primary_card?

  private

  def user_has_primary_card?
    user = User.find(self.user_id)
    user.primary_card.present?
  end

  def save_as_primary
    self.is_primary = true
  end
end

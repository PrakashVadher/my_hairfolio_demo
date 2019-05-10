class Claim < ApplicationRecord
  attr_accessor :send_claim_email
  belongs_to :salon

  validates_presence_of :contact_number, :email, :salon
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validate :email_uniqueness, on: :create
  validate :already_claimed?, on: :create
  validate :salon_can_be_claimed?, on: :create
  validate :already_approved?
  before_save :set_claim_approved_flag, if: :claim_approved?
  validate :claim_can_be_approved?
  after_commit :send_claim_approved_email, if: :send_claim_email

  def email_uniqueness
    if User.where(email: email).any?
      errors.add(:email, I18n.t('claims.email_taken'))
    elsif  Claim.where(email: email).where.not(salon_id: salon_id).exists?
      errors.add(:base, I18n.t('claims.already_claimed_another_salon'))
    end
  end

  def already_claimed?
    errors.add(:base, I18n.t('claims.already_claimed')) if Claim.where(email: email, salon_id: salon_id).where.not(id: id).exists?
  end

  def salon_can_be_claimed?
    errors.add(:salon, I18n.t('claims.can_not_claimed')) unless salon.can_claim
  end

  def already_approved?
    errors.add(:base, I18n.t('claims.disaprove_not_allow')) if will_save_change_to_approve? && approve_was
  end

  def claim_approved?
    will_save_change_to_approve? && approve
  end

  def claim_can_be_approved?
    if will_save_change_to_approve? && approve
      errors.add(:base, I18n.t('claims.can_not_be_approved')) if salon.owner.present? && (salon.owner.email != email)
    end
  end

  def set_claim_approved_flag
    @send_claim_email = true
  end

  def send_claim_approved_email
    user = User.find_or_create_by(email: email)
    password = Devise.friendly_token.first(12)
    user.update_attributes(password: password, password_confirmation: password, account_type: :owner, salon_id: salon_id)
    SalonClaimMailer.claim_approved(self.salon.reload, password).deliver_now
  end
end

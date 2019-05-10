class Authentication < ApplicationRecord
  belongs_to :provider
  belongs_to :user
  validates_presence_of :provider, :user

  serialize :params

  scope :facebook, -> { joins(:provider).where("providers.name = 'facebook'") }
  scope :instagram, -> { joins(:provider).where("providers.name = 'instagram'") }

  after_create :update_user_ids


  def self.create_from_koala(params, user, provider)
    create(
      user: user,
      provider: provider,
      uid: params['id'],
      token: params['token'],
      params: params
    )
  end

  def self.create_from_instagram(token, params, user, provider)
    create(
      user: user,
      provider: provider,
      uid: params.id,
      token: token,
      params: params
    )
  end

  def update_user_ids
    if provider.name == 'facebook'
      user.update(facebook_id: uid)
    else
      user.update(instagram_id: uid)
    end
  end
end

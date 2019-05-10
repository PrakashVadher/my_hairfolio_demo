FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user
    recipient_ids {[ create(:user).id]}
    after :create do |conversation|
      create(:message, conversation: conversation, user: conversation.sender)
    end
  end
end

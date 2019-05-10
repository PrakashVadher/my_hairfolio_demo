class RenameStripeCardToCard < ActiveRecord::Migration[5.2]
  def change
    rename_table :stripe_cards, :cards
  end
end

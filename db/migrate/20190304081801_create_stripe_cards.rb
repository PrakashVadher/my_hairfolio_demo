class CreateStripeCards < ActiveRecord::Migration[5.2]
  def change
    create_table :stripe_cards do |t|
      t.references :user
      t.string :stripe_card_id
      t.boolean :is_primary, default: false
      t.timestamps
    end
  end
end

class Relation < ApplicationRecord
  belongs_to :product
  belongs_to :related_product, class_name: 'Product'

  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.where(inverse_match_options).any?
  end

  def inverses
    self.class.where(inverse_match_options)
  end

  def inverse_match_options
    { product_id: related_product_id, related_product_id: product_id }
  end
end

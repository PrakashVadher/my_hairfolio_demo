namespace :product_image do
  desc "seed product default image"
  task :seed_product_images => :environment do
    Rails.logger.debug('Seed started')
    Product.all.each do |product|
      product.remove_product_image!
      product.save!
      Rails.logger.debug("Product: #{product.id}")
      product_images = "app/assets/images/product#{rand 1..14}.jpeg"
      product.update(product_image: File.open(File.join(Rails.root, product_images)))
    end
    Rails.logger.debug('Seed completed')
  end
end
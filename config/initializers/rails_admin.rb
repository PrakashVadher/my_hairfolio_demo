RailsAdmin.config do |config|

  config.authorize_with do
    authenticate_or_request_with_http_basic('Site Message') do |username, password|
      username == 'admin@hairfolioapp.com' && password == '!hairfolio2019'
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true
  #
  config.model User do
    edit do
      field :first_name
      field :last_name
      field :email do
        read_only true
      end
      field :password
      field :account_type
    end
    show do
      exclude_fields :referral_code
    end
  end

  config.model Product do
    edit do
      field :name do
        required true
        html_attributes do
          { :minlength => 3 }
        end
      end
      field :product_image do
        required true
        pretty_value do
          bindings[:view].tag(:img, { :src => bindings[:object].product_image.url, :height => '150px', :width => '200px' }) if bindings[:object].product_image.url.present?
        end        
      end
      field :price, :decimal do
        required true
        html_attributes do
          { :maxlength => 6}
        end
      end
      field :quantity do
        required true
        html_attributes do
          { :maxlength => 6}
        end
      end
      field :description do
        required true
      end
      field :short_description do
        required true
      end
      field :favourites_count do
        read_only true
      end
      field :categories do
        partial 'categories'
      end
      include_all_fields
      field :related_products do
        inline_add false
      end
      field :product_brand do
        inline_add false
        inline_edit false
      end
      exclude_fields :favourites,:carts, :posts, :tag, :favourites_count, :relations, :sale, :item, :active_sale_item, :active_sale
    end
    list do
      field :id
      field :name
      field :image_url
      field :link_url
      field :created_at
    end
    show do
      exclude_fields :relations
    end
  end

  config.model Page do
    field :title
    field :slug
    field :content, :ck_editor
  end

  config.model Blog do
    field :title
    field :description, :ck_editor
    field :image
  end

  config.model Tag do
    list do
      scopes [:popular, :popular_today, :popular_last_48_hours, :popular_last_7_days, :popular_last_30_days]
    end
  end

  config.model Post do
    edit do
      field :user
      field :description
      field :products
      field :is_trending
      field :is_editors_pic
    end
    list do
      field :id do
        formatted_value do
          "Post ##{bindings[:object].id}"
        end
      end
      field :user
      field :description
      field :post_image do
        formatted_value do
          bindings[:view].tag(:img, { :src => bindings[:object].post_image, :width => "150px", :height => "150px" }, )
        end
      end
      field :created_at
      # field :updated_at
    end
    show do
      field :user
      field :description
      field :post_image do
        formatted_value do
          bindings[:view].tag(:img, { :src => bindings[:object].post_image, :width => "150px", :height => "150px" }, )
        end
      end
      field :likes_count
      field :comments_count
      field :products
      field :folios
      field :likes
      field :photos
      field :created_at
    end
  end

  config.model ProductGallery do
    edit do
      field :image_url do
        label "Upload Image"
      end
    end
    visible false
  end

  config.model Cart do
    edit do
      field :user      
      field :products
      field :price
      field :quantity
    end
  end

  config.model Category do
    edit do
      field :name do
        required true
      end
      field :image do 
        required true
      end
      
      field :parent_id, :enum do
        enum_method do
          :parent_enum
        end
      end
    end
    nestable_tree({
      position_field: :position,
      live_update: false,
      max_depth: 2
    })
  end

  config.model GlobalVar do
    list do
      field :id
      field :name do
        pretty_value do
          value.titleize
        end
      end
      field :value
      field :created_at
    end
    edit do
      field :name do
        read_only true
        pretty_value do
          value.titleize
        end
      end
      field :value, :integer do
        help 'Required - Eneter percentage value'
      end
    end
  end

  config.model Order do
    edit do
      field :delivery_user_id, :enum do
        visible do
          bindings[:object].delivery_user_id.nil?
        end
        enum do
          User.delivery.collect {|p| [p.full_name, p.id]}
        end
      end

      field :shipping_status
    end
    list do
      field :id
      field :order_number
      field :user
      field :shipping_status
      field :payment_status
      field :delivery_user
      field :address
      field :created_at
      field :updated_at
    end
    show do
      field :user
      field :order_number #number_with_precision(1.5, :precision =>
      field :payment_status
      field :shipping_status
      field :address
      field :amount do
        formatted_value{ bindings[:object].amount.round(2) }
      end
      field :wallet_amount do
        formatted_value{ bindings[:object].wallet_amount.round(2) }
      end
      field :coupon_amount do
        formatted_value{ bindings[:object].coupon_amount.round(2) }
      end
      field :final_amount do
        formatted_value{ bindings[:object].final_amount.round(2) }
      end
      field :discount do
        formatted_value{ bindings[:object].discount.round(2) }
      end
      field :order_details
      field :push_notifications
      field :payment_transaction
    end
  end

  config.model Refer do
    list do
      field :id
      field :unique_code
      field :user do
        queryable true
        searchable [:first_name, :last_name]
      end
      field :post
      field :created_at
      field :updated_at
      field :refer_counts
      field :refer_histories
    end
  end

  config.model ReferHistory do
      list do
        field :id
        field :user do
          label "Buyer User"
        end
        field :refer do
          queryable true
          searchable [:id]
        end
        field :created_at
        field :updated_at       
      end
  end

  config.model Sale do
    edit do
      field :start_date
      field :end_date
      field :image do
        label "Upload Image (1717*558px)"
      end
      field :discount_percentage
      field :products do
        inline_add false
      end
    end
    list do
      field :start_date
      field :end_date
      field :image
      field :discount_percentage
    end
    show do
      exclude_fields :items
    end
  end
  
  config.model Relation do
    visible false
  end
  # config.model HairType do
  #   visible false
  # end
  # config.model ConsistencyType do
  #   visible false
  # end
  # config.model ProductType do
  #   visible false
  # end
  # config.model Preference do
  #   visible false
  # end
  # config.model StylingTool do
  #   visible false
  # end
  # config.model Ingredient do
  #   visible false
  # end
  # config.model Shampoo do
  #   visible false
  # end
  config.model Conditioner do
    visible false
  end
  config.model StylingProduct do
    visible false
  end
  config.model Collection do
    visible false
  end
  config.model Homepagepost do
    visible false
  end
  # config.model Sale do
  #   visible false
  # end
  # config.model Refer do
  #   visible false
  # end
  # config.model ReferHistory do
  #   visible false
  # end
  config.model ReferralHistory do
    #visible false
    list do
      field :id
      field :referrer
      field :referral_recipient
      field :referral_code
      field :created_at
    end
  end
  config.model Coupon do
    visible false
    list do
      field :id
      field :referent do
        queryable true
        #searchable [:first_name, :last_name]
        #searchable [{User => :first_name,User => :last_name, Salon => :name, Brand => :name}]
      end
      field :referrer do
        queryable true
        #searchable [:first_name, :last_name]
        # filterable true
        # searchable true
        #searchable [{User => :first_name,User => :last_name, Salon => :name, Brand => :name}]
      end
      field :coupon_code
      field :created_at
      field :updated_at
      field :discount_percentage
    end
  end
  config.model Wallet do
    visible false
  end  
  # config.model GlobalVar do
  #   visible false
  # end
  config.model PaymentTransaction do
    visible false
    list do
      field :id
      field :amount do
        formatted_value{ bindings[:object].amount.round(2) }
      end
      field :transaction_type
      field :stripe_charge_id
      field :created_at
      field :updated_at
      field :user
    end

    show do
      field :amount do
        formatted_value{ bindings[:object].amount.round(2) }
      end
      field :transaction_type
      field :user
    end
  end
  config.model StoreShopIt do
    visible false
  end
  config.model WalletCommissionList do
    visible false
  end
  config.model StoreLandingSale do
    visible false
  end

  #config.label_methods = [:rails_admin_title]
  config.model Homepage do
    label "Homepage Rows"
    edit do
      field :title_heading
      # field :posts do
      #   partial "home_post_list"
      # end
      field :posts
      field :status
    end
    list do
      field :title_heading
      field :posts
      field :status
      field :created_at
      field :updated_at
    end
  end

  config.model ProductBrand do
    label "Product Brand"
    edit do
      field :title, :string do
        required true
        html_attributes do
          {:maxlength => 100, :minlength => 3}
        end
      end
      include_all_fields
    end
  end

  config.model DiscountSlider do
    label "Top Banner Image"
    edit do
      field :banner_image do
        label "Banner Image (1920*720px)"
      end
      include_all_fields
    end
  end
  config.model Item do
    visible false
  end
  config.model SalonImage do
    visible false
  end
  config.model SalonService do
    visible false
  end
  config.model SalonBusinessInfo do
    visible false
  end
  config.model SalonTiming do
    visible false
  end
  config.model Section do
    visible false
  end

  config.model Claim do
    visible false
    edit do
      field :salon do
        read_only true
      end
      field :email do
        read_only true
      end
      field :contact_number do
        read_only true
      end
      field :approve
    end
  end

  config.model Salon do
    visible false
  end

  config.model Service do
    visible false
  end

  # Register the class in lib/rails_admin_publish.rb
  module RailsAdmin
    module Config
      module Actions
        class Publish < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index
    new do
      except ['Cart', 'Order', 'OrderDetail', 'Refer', 'PushNotification', 'ReferralHistory', 'GlobalVar', 'Relation',
              # 'ProductType', 'Preference', 'ConsistencyType', 'StylingTool','Shampoo', 'Conditioner',
             'Collection', 'StylingProduct', 'Item', 'Claim',
             'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService', 'Post','Coupon','ReferHistory'].append(Sale.add_for_new)
    end
    export do
      except ['Relation','HairType', 'ProductType', 'Ingredient', 'Preference', 'ConsistencyType', 'StylingTool',
              'Shampoo', 'Conditioner', 'Collection', 'StylingProduct', 'Sale', 'Item',
              'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService','Homepage','DiscountSlider']
    end
    bulk_delete do
      except ['Relation', 
              # 'ProductType', 'Ingredient', 'Preference', 'ConsistencyType', 'StylingTool',
              # 'Shampoo', 'Conditioner', 'Collection', 'StylingProduct', 
              'Sale', 'Item', 'Claim',
              'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService', 'Homepage','DiscountSlider', 'Post']
    end
    show do
      except ['Relation', 'Item']
    end
    edit do
      except ['Cart', 'PushNotification', 'ReferralHistory', 'Relation', 'Collection', 'StylingProduct',
              # 'ProductType', 'Preference', 'ConsistencyType', 'StylingTool','Shampoo', 'Conditioner',
              'Item', 'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService', 'Post','Coupon','ReferHistory', 'Refer']
    end
    delete do
      except ['PushNotification', 'Order', 'ReferralHistory', 'GlobalVar', 'Relation',
               # 'ProductType', 'Preference', 'ConsistencyType', 'StylingTool', 'Shampoo', 'Conditioner',
              'Collection', 'StylingProduct', 'Sale', 'Item',
              'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService','Homepage','DiscountSlider','Coupon','ReferHistory', 'Refer']
    end
    show_in_app do
      except ['Cart', 'Relation', 'Item']
    end
    import do
      except ['ReferralHistory', 'GlobalVar', 'Relation',
              'HairType', 'ProductType', 'Ingredient', 'Preference', 'ConsistencyType', 'StylingTool',
              'Shampoo', 'Conditioner', 'Collection', 'StylingProduct', 'Sale', 'Item', 'Claim',
              'SalonImage', 'SalonTiming', 'SalonBusinessInfo', 'Section', 'SalonService','Homepage','DiscountSlider', 'Post']
    end
    nestable
    ## With an audit adapter, you can add:
    # history_index
    # history_show

  end

end


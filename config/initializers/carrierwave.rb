CarrierWave.configure do |config|
  #if Rails.env.staging? || Rails.env.production?
    #config.fog_provider = 'fog/aws' #fog/aws
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => Rails.application.secrets.aws_access_key_id,
      :aws_secret_access_key => Rails.application.secrets.aws_secret_access_key,
      :region => 'us-west-1' # US West (N. California)
    }
    config.fog_directory = Rails.application.secrets.aws_bucket_name
    config.storage = :fog
  #else
    # config.storage = :file
    # config.enable_processing = Rails.env.development?
  #end
end
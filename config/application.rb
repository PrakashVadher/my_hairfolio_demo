require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Hairfolio
  class Application < Rails::Application
    #config.load_defaults 5.2
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Rails 5

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :put, :delete]
      end
    end
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.exceptions_app = self.routes
    config.generators do |g|
      g.test_framework :rspec
    end

  end

end

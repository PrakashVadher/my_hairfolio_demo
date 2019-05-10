namespace :generate do
  desc "TODO"
  task :docs => :environment do
    system('calamum -f api_docs.json -t twitter -p ~/hairfolio/public')
  end
end

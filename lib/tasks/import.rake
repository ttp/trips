require_relative '../import/trips'
require_relative '../import/menu'

namespace :import do
  namespace :trips do
    desc "import tracks"
    task :tracks  => :environment do
      filename = ENV['DATA']
      import_service = Import::Trips.new(ENV['USER'])
      import_service.import_tracks(filename)
    end

    desc "import trips"
    task :trips => :environment do
      filename = ENV['DATA']
      import_service = Import::Trips.new(ENV['USER'])
      import_service.import_trips(filename)
    end

    task :all => [:tracks, :trips]
  end
  task :trips => 'trips:all'

  namespace :menu do
    desc "import products, DATA=products.csv"
    task :products => :environment do
      puts "importing products"
      filename = ENV['DATA']
      import_service = Import::Menu.new
      import_service.import_products(filename)
    end

    desc "import dishes, DATA=dishes.csv"
    task :dishes => :environment do
      puts "importing dishes"
      filename = ENV['DATA']
      import_service = Import::Menu.new
      import_service.import_dishes(filename)
    end

    desc "clean all menu tables including users data"
    task :clean => :environment do
      puts "clean all menu data"
      import_service = Import::Menu.new
      import_service.clean
    end

    desc "clean all menu data & import default seed data"
    task :default => :environment do
      import_service = Import::Menu.new
      puts "cleaning all menu data"
      import_service.clean
      puts "importing default meals"
      import_service.import_meals(Rails.root.join('db', 'seeds', 'menu_meals.csv'))
      puts "importing default products"
      import_service.import_products(Rails.root.join('db', 'seeds', 'menu_products.csv'))
      puts "importing default dishes"
      import_service.import_dishes(Rails.root.join('db', 'seeds', 'menu_dishes.csv'))
    end
  end
end

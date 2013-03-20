require_relative '../import'

namespace :import do
  desc "import categories"
  task :tracks  => :environment do
    filename = ENV['DATA']
    import_service = ImportService.new(ENV['USER'])
    import_service.import_tracks(filename)
  end

  task :trips => :environment do
    filename = ENV['DATA']
    import_service = ImportService.new(ENV['USER'])
    import_service.import_trips(filename)
  end

  task :all => :environment do
    filename = ENV['DATA']
    import_service = ImportService.new(ENV['USER'])
    import_service.import_tracks(filename)
    import_service.import_trips(filename)
  end
end
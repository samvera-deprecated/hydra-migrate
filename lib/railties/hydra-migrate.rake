namespace :hydra do
  desc "Run ActiveFedora model migrations"
  task :migrate, [:models] => :environment do |t,args|
    migrator = Hydra::Migrate::Dispatcher.new
    migrator.load_migrations(File.join(Rails.root,'db/hydra'))
    models = (args[:models] || 'ActiveFedora::Base').split(/[,;\s]+/)
    models.each do |model|
      klass = model.split(/::/).inject(Module) { |k,c| k.const_find(c.to_sym) }
      klass.find(:all).each do |obj|
        while migrator.can_migrate? obj
          $stderr.puts "Migrating #{obj.class} #{obj.pid} from #{obj.current_migration.inspect} to #{version.inspect}"
          migrator.migrate! obj
        end
      end
    end
  end
end
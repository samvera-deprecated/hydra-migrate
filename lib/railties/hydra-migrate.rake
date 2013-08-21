namespace :hydra do
  desc "Run ActiveFedora model migrations"
  task :migrate, [:models] => :environment do |t,args|
    migrator = Hydra::Migrate::Dispatcher.new
    migrator.load_migrations(File.join(Rails.root,'db/hydra'))
    models = (args[:models] || 'ActiveFedora::Base').split(/[,;\s]+/)
    models.each do |model|
      klass = model.split(/::/).inject(Module) { |k,c| k.const_get(c.to_sym) }
      klass.find_each({},{:cast=>true}) do |obj|
        while migrator.can_migrate? obj
          migrator.migrate!(obj) do |o,m,d|
            current = o.current_migration
            current = 'unknown version' if current.blank?
            $stderr.puts "Migrating #{o.class} #{o.pid} from #{current} to #{m[:to]}"
          end
        end
      end
    end
  end
end
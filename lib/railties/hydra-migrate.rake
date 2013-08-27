namespace :hydra do
  desc "Run ActiveFedora model migrations"
  task :migrate => :environment do |t,args|
    models = env['models'].split(/[,;\s]+/).collect do |model_name|
      model_name.split(/::/).inject(Module) { |k,c| k.const_get(c.to_sym) }
    end
    target_version = env['to']
    Hydra::Migrate::Dispatcher.migrate_all!(models, to: target_version, path: File.join(Rails.root,'db/hydra')) do |o,m,d|
      current = o.current_migration
      current = 'unknown version' if current.blank?
      $stderr.puts "Migrating #{o.class} #{o.pid} from #{current} to #{m[:to]}"
    end
  end
end
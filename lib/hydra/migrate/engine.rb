module Hydra
  module Migrate
    class Engine < Rails::Engine
      # Load rake tasks
      rake_tasks do
        task_spec = File.join(File.expand_path('../..',File.dirname(__FILE__)),'railties', '*.rake')
        Dir.glob(task_spec).each do |railtie|
          load railtie
        end
      end
    end 
  end
end

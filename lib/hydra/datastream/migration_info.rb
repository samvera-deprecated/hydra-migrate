module Hydra
  module Datastream
    class MigrationInfo < ActiveFedora::OmDatastream
      set_terminology do |t|
        t.root(:path=>"migrationInfo", :xmlns=>"http://hydra-collab.stanford.edu/schemas/migrationInfo/v1", :namespace_prefix=>nil)
        t.current
        t.migration do
          t.from(:path=>'@from')
          t.to(:path=>'@to')
          t.at(:path=>'@at')
        end
      end

      class << self
        attr_accessor :default_version

        def xml_template
          %{'<migrationInfo xmlns="http://hydra-collab.stanford.edu/schemas/migrationInfo/v1"/>'}
        end
      end

      define_template :migration do |xml, from, to, at=Time.now|
        xml.migration :from=>from, :to=>to, :at=>at
      end

      def migrate(to)
        add_child_node(ng_xml.root, :migration, current, to, Time.now)
      end

      def current
        result = self.find_by_terms(:current).text
        result = self.class.default_version if result.blank?
        result
      end
    end
  end
end

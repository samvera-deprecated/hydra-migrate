require 'active_fedora'

module Hydra
  module Datastream
    class MigrationInfo < ActiveFedora::OmDatastream
      set_terminology do |t|
        t.root(:path=>"migrationInfo", :xmlns=>"http://hydra-collab.stanford.edu/schemas/migrationInfo/v1", :namespace_prefix=>nil)
        t.current
        t.history do
          t.migration do
            t.from(:path=>'@from', :namespace_prefix=>nil)
            t.to(:path=>'@to', :namespace_prefix=>nil)
            t.at(:path=>'@at', :namespace_prefix=>nil)
          end
        end
      end

      def self.xml_template
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.migrationInfo(:xmlns=>"http://hydra-collab.stanford.edu/schemas/migrationInfo/v1") {
            xml.current
            xml.history
          }
        end
        builder.doc
      end

      define_template :migration do |xml, from, to, at=Time.now|
        xml.migration :from=>from, :to=>to, :at=>at
      end

      def migrate(to)
        add_child_node(find_by_terms(:history), :migration, current.first.to_s, to, Time.now)
      end
    end
  end
end

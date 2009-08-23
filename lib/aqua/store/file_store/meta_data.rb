module Aqua
  module Store
    module FileStore
      
      # A helper class to help manage all the meta data information required
      # for the Aqua::Store::FileStore.
      class MetaData
            
        #
        # === Class
        #
      
        # init the MetaData class with Aqua::Store::FileStore adapter and datastore directory.
        # @param [String] a Aqua::Store::FileStore adapter
        # @params [String] a directory where the data files will be stored to and read from.
        def self.init(adapter, directory)
          raise( ArgumentError, "adapter and directory can not be blank." ) if adapter.empty? || directory.empty?
          @_metadatas  = nil
          @_adapter    = Kernel.const_get( adapter )
          @_directory  = directory
          # TODO: load all meta data information.
          file_extension = @_adapter.file_extension
          Dir.glob( "#{@_directory}/**/*.#{file_extension}" ).sort { |a,b| File.basename(a,file_extension).to_i - File.basename(b,file_extension).to_i }.each do |datafile|
            paths = datafile.split( File::SEPARATOR )
            file      = paths.pop
            resource  = paths.pop
            id        = File.basename(file, file_extension).to_i
            #self[resource] ||= MetaData.new
            self[resource].last_id = id
          end
          self
        end
        
        # a Mash representing all the MetaData information.
        # the key is a pluralized and downcase version of the 
        # class being stored.
        #
        # for example: User would be users.
        #
        # to access the meta data based on the key, use the MetaData[] method.
        # @example to get meta data for users resources
        #   MetaData['user'] or MetaData[:users]
        def self.metadatas
          @_metadatas ||= Mash.new
        end
        
        # get the MetaData for a particular resource. 
        #
        # @example, to get the MetaData for User
        #   MetaData['users'] or MetaData[:users]
        #
        # @example, to get the MetaData for Person
        #   MetaData['people'] or MetaData[:people]
        def self.[](key)
          metadatas[key] ||= MetaData.new
        end  
        
        def self.create_or_update( document )
          document[:_id] = MetaData.next_id_for_class( document ) unless document[:_id]
          file = self.file_for_document( document )
          ensure_directory( file )
          self._adapter.create_or_update( document, file )
        end
        
        def self.file_for_document( document )
          key = self.key_from_class( document )
          self[key].file_for_document( document )
        end
        
        def self.next_id_for_class( klass )
          key = self.key_from_class( klass )
          self[key].next_id
        end
        
        def self.ensure_directory( file )
          directory = File.split( file ).first
          FileUtils.mkdir_p( directory )
        end

        def self.key_from_class( klass )
          if klass.is_a?( String )
            klass_string = klass
          elsif klass.is_a?( Class )
            klass_string = klass.to_s
          else  
            klass_string = klass.class.to_s
          end
          klass_string.pluralize.downcase
        end
        
        # the Aqua::Store::FileStore adapter being used.
        # @return the adapter
        def self._adapter
          @_adapter
        end
        
        # the Aqua::Store::FileStore directory being used.
        # @return [String] the directory
        def self._directory
          @_directory
        end
        
        
        
        #
        # === Instance Methods
        #
        attr_accessor :last_id
        
        def initialize(*args)
          self.last_id = 0
        end
        
        def file_for_document( document )
          return nil unless document[:_id]
          "#{_directory}/#{key_from_class( document )}/#{document[:_id]}.#{_adapter.file_extension}"
        end
        
        def _directory
          self.class._directory
        end
        
        def _adapter
          self.class._adapter
        end
        
        def key_from_class( document )
          self.class.key_from_class( document )
        end
        
        def next_id
          last_id + 1
        end
        
      end
      
    end
  end
end
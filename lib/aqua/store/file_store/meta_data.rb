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
        
        def self.next_id_for_class( klass )
          key = klass.pluralize.downcase
          puts "key: #{key}"
          self[key].next_id
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
        
        def next_id
          last_id + 1
        end
        
      end
      
    end
  end
end
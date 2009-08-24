require File.dirname( __FILE__ ) + "/storage_methods" unless defined?( Aqua::Store::FileStore::StorageMethods )
require File.dirname( __FILE__ ) + "/meta_data" unless defined?( Aqua::Store::FileStore::MetaData )

module Aqua
  module Store
    
    # A FileStore for Aqua.  The underlying file storage can use PStore or YAML.
    module FileStore
      
      # @raise if the Filesystem Adapter isn't found
      class AdapterNotFound < LoadError; end
      
      # @raise if the directory for the FileStore isn't found
      class DirectoryNotFound < LoadError; end
      
      # initialize the file store with an adapter, directory and loads 
      # the initial meta data.
      #
      # this is equivalent to calling set_adapter, set_directory, and load manually.
      # 
      # @example set an adapter and directory
      #   Aqua::Store::FileStore.init( :adapter => "YAMLAdapter", :directory => "/tmp" )
      #
      # @example set a directory and stick with default adapter (YAMLAdapter)
      #   Aqua::Store::FileStore.init( :directory => "/tmp" )
      #
      # @example set the adapter and stick with default directory
      #   Aqua::Store::FileStore.init( :adapter => "PStoreAdapter" )
      #
      # @see Aqua::Store::FileStore#set_adapter
      # @see Aqua::Store::FileStore#set_directory
      # @param [Hash] a hash that can contain adapter, directory.
      def self.init(*args)
        options = args.shift || {}
        raise( ArgumentError, "expected a hash or nothing, but received #{arg.class}") unless options.is_a?( Hash )
        set_adapter( options[:adapter] )
        set_directory( options[:directory] )
        load_metadata
      end
      
      # clears all the current settings for the FileStore.
      # this is basically only useful in testing...
      def self.clear_settings
        @adapter    = nil
        @directory  = nil
        @metadata   = nil
        #TODO: if any modules get mixed in we need to remove them too!
      end
      
      # the adapter used to handle actual storage to file
      # @return an adapter to handle the actual storage to file.
      def self.adapter
        @adapter ||= set_adapter
      end
      
      # sets the underlying adapter for handling the reading/writing from
      # the filesystem.  There a two options at this time "YAMLAdapter" and
      # "PStoreAdapter".
      # 
      # @example 
      #
      # @param [String] the adapter module, default is "YAMLAdapter"
      def self.set_adapter( adapter = "YAMLAdapter" )
        adapter ||= "YAMLAdapter"
        unless adapter == "PStoreAdapter"
          filename = adapter.underscore
        else
          # need to handle pstore a little bit differently,
          # since "PStoreAdapter".underscore evaluates to
          # p_store_adapter.  Just thought the file name
          # looks better as pstore_adapter.
          filename = "pstore_adapter"
        end
        
        # TODO: need to make it so we can load adapters that don't reside in the file_system/adapter directory
        adapter_dir = File.dirname( __FILE__ ) + "/file_system/adapter"
        adapter_file = "#{adapter_dir}/#{filename}"
        require adapter_file
        
        @adapter = adapter
      rescue LoadError
        raise( AdapterNotFound, "unable to find adapter '#{adapter}', tried to load '#{adapter_file}'")
      end
      
      # the directory the Aqua::Store::FileStore uses to store files.
      # @see set_directory
      def self.directory
        @directory ||= set_directory
      end
      
      # sets the directory to use for Aqua::Store::FileStore.  the directory string
      # is appended with /data.  
      #
      # @example use current directory
      #   Aqua::Store::FileStore.set_directory # will return /<current directory path>/data
      # 
      # @example use '/tmp' directory
      #   Aqua::Store::FileStore.set_directory("/tmp") # will return /tmp/data
      #   
      # @param [String] the directory to use, default is Dir.pwd
      # @return [String] the directory string appended with /data.
      def self.set_directory( dir = Dir.pwd )
        dir ||= Dir.pwd
        raise DirectoryNotFound unless File.directory?( dir )
        @directory = "#{dir}/datastore"
        FileUtils.mkdir_p( @directory ) unless File.directory?( @directory )
        # TODO: catch FileUtils.mkdir_p exceptions and raise a FileStore exception of some kind.
        @directory
      end
      
      # @return [Aqua::Store::FileStore::MetaData] the current meta data class, not an instance of.
      def self.metadata
        @metadata ||= load_metadata
      end
      
      # loads metadata based on adapter and directory.  before calling metadata or load_metadata make
      # sure you have the correct adapter and directory set.  the suggested route is to use FileStore.init
      # where you can specify the adapter, directory and the meta data gets loaded.
      def self.load_metadata
        @metadata = MetaData.init( self.adapter, self.directory )
      end
      
    end
  end
end
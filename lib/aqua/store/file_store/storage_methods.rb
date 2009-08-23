module Aqua
  module Store
    module FileStore
      
      # Storage Methods for a filesystem datastore.
      #
      # @see Aqua::Storage for details on the require methods for a storage library.
      module StorageMethods
   
        def self.included( klass ) 
          klass.class_eval do 
            include InstanceMethods
            extend ClassMethods
          end
        end   
        
        module ClassMethods

          # Initializes a new storage document and saves it without raising any errors
          # 
          # @param [Hash, Mash]
          # @return [Aqua::Storage, false] On success it returns an aqua storage object. On failure it returns false.
          # 
          # @api public          
          def create( hash = {} )
            doc = new( hash )
            doc.save
          end
          
          # Initializes a new storage document and saves it raising any errors.
          # 
          # @param [Hash, Mash]
          # @return [Aqua::Storage] On success it returns an aqua storage object. 
          # @raise Any of the FileStore exceptions
          # 
          # @api public
          def create!( hash )
            doc = new( hash )
            doc.save!
          end
          
          
        end
        
        module InstanceMethods
          
          # initializes a new Aqua::Storage suitable for FileStore.
          #
          # @param [Hash, Mash] 
          # @return [Aqua::Storage] a storage document
          #
          # @api public
          def initialize( hash={} )
            super( hash )
          end
          
          # Saves an Aqua::Storage to the Aqua::Store::FileStore
          #
          # @return [Aqua::Storage, false] Will return false if the document is not saved. Otherwise it will return the Aqua::Storage object.
          #
          # @api public
          def save
            begin
              create_or_update
            rescue
              puts $!
              return false
            end
          end
          
          # Saves an Aqua::Storage to the Aqua::Store::FileStore, will raise an exceptions that may occur.
          #
          # @return [Aqua::Storage] if the commit was successful
          # @raise FileStore exceptions if any were raised
          #
          # @api public
          def commit
            create_or_update
          end
          alias :save! :commit
          
          # Returns true if the record hasn't been saved.
          # @return [Boolean] true if the record hasn't been saved to the file system.
          def new_record?
            # TODO: we probably can only check to see that created_at has been set, and it should be set after
            # the record has been saved.
            self[:created_at].nil?
          end
          
          
          private
          
          # responsible for creating or updating the record based on whether the
          # record is a new record or not.
          # TODO: add call backs, probably could do so through another module
          def create_or_update
            MetaData.create_or_update( self )
          end
          
        end
        
      end
    end
  end
end
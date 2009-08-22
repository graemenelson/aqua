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
            
          end
          
          # Saves an Aqua::Storage to the Aqua::Store::FileStore, will raise an exceptions that may occur.
          #
          # @return [Aqua::Storage] if the commit was successful
          # @raise FileStore exceptions if any were raised
          #
          # @api public
          def commit
            
          end
          alias :save! :commit
          
          # TODO: we need to handle update/create
          # TODO: on create we need to assign a unique id -- maybe look at how stone does it.
          
        end
        
      end
    end
  end
end
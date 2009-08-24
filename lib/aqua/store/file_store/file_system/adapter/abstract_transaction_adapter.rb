module AbstractTransactionAdapter
  
  def self.store( store, document )
    store.transaction do 
      document.each_pair do |key, value|
        if ( value.is_a?( Hash ) )
          
        elsif ( value.is_a?( Array ) )
          
        else
          store[key.to_s] = value
        end
      end
    end
    document
  end
  
end
module AbstractTransactionAdapter
  
  def self.store( s, document )
    created_at = nil
    s.transaction do 
      # need to set attributes here...
      s['_id'] = document['_id']
      if document['created_at'].nil?
        created_at = s['create_at'] = Time.now
      end
    end
    document[:created_at] ||= created_at unless created_at.nil?
    document
  end
  
end
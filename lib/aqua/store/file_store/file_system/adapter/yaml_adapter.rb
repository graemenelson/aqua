require 'yaml'
require 'yaml/store'
require File.dirname( __FILE__ ) + "/abstract_transaction_adapter"
module YAMLAdapter
  
  
  def self.file_extension
    "yml"
  end
  
  def self.create_or_update( document, file )
    store = YAML::Store.new( file, :Indent => 2 )
    AbstractTransactionAdapter.store( store, document )
    document
  end
  
end
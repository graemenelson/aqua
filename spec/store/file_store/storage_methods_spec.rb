require File.dirname(__FILE__) + "/spec_helper"

describe Aqua::Store::FileStore::StorageMethods do
 
  before( :each ) do
    # NOTE: this needs be defined here and not outside of the rspec describe block,
    # otherwise we get collisions going on.
    Aqua.set_storage_engine( 'FileStore' ) # to initialize the Aqua::Store namespace
    class Document < Mash 
      include Aqua::Store::FileStore::StorageMethods
    end
  end
  
  describe 'create' do
    
    before( :each ) do
      @params = {
        :first_name => "John",
        :last_name  => "Smith"
      }
      @doc = Document.create( @params )
    end
    
    it "should an id be assigned at this point"
    
    it "should contain the first name"
    
    it "should contain the last name"
    
    it "should have created_at"
    
  end
  
  
  
end
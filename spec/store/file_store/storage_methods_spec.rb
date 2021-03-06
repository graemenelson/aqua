require File.dirname(__FILE__) + "/spec_helper"

describe Aqua::Store::FileStore::StorageMethods do
 
  before( :each ) do
    
    # NOTE: this needs be defined here and not outside of the rspec describe block,
    # otherwise we get collisions going on.
    Aqua.set_storage_engine( 'FileStore' ) # to initialize the Aqua::Store namespace
    Aqua::Store::FileStore.init( :directory => SANDBOX_DIR ) # init with defaults
    class Document < Mash 
      include Aqua::Store::FileStore::StorageMethods
    end
  end
  
  after( :each ) do
    FileUtils.rm_rf( "#{SANDBOX_DIR}/datastore" )
  end
  
  describe 'save' do
    
    before( :each ) do
      @params = {
        :first_name => "John",
        :last_name  => "Smith"
      }
      @doc = Document.create( @params )
    end
    
    it "should an id be assigned at this point" do
      @doc[:_id].should == 1
    end
    
    it "should not be a new record" do
      @doc.should_not be_new_record
    end
    
    it "should have created_at" do
      @doc[:created_at].should_not be_nil
    end
    
  end
  
  
  
end
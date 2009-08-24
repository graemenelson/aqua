require File.dirname(__FILE__) + '/spec_helper'

FileStore = Aqua::Store::FileStore unless defined?( FileStore )
describe FileStore do

  before( :each ) do
    FileStore.clear_settings
  end

  describe 'configuration' do
    
    describe 'init' do
      
      describe 'with no values' do
        
        before( :each ) do
          FileUtils.should_receive( :mkdir_p ).with( "#{Dir.pwd}/datastore")
          FileStore.init
        end
      
        
        it "should set default file adapter" do
          FileStore.adapter.should == "YAMLAdapter"
        end
        
        it "should set default directory" do
          FileStore.directory.should == "#{Dir.pwd}/datastore"
        end
        
      end
      
      describe 'with just adapter set to PStore' do
        
        before( :each ) do
          FileUtils.should_receive( :mkdir_p ).with( "#{Dir.pwd}/datastore")
          FileStore.init( :adapter => "PStoreAdapter" )
        end
        
        it "should set file adapter to 'PStoreAdapter'" do
          FileStore.adapter.should == "PStoreAdapter"
        end
        
        it "should set default directory" do
          FileStore.directory.should == "#{Dir.pwd}/datastore"
        end        
        
      end
      
    end
    
    describe 'set_file_adapter' do

      describe 'is not called' do

        it "should set adapter to YAMLAdapter" do
          FileStore.adapter.should == "YAMLAdapter"
        end

      end

      describe 'set file adapter with YAMLAdapter' do

        before( :each ) do
          FileStore.set_adapter( "YAMLAdapter" )
        end

        it "should set adapter to YAMLAdapter" do
          FileStore.adapter.should == "YAMLAdapter"
        end

      end

      describe 'set file adapter with PStoreAdapter' do

        before( :each ) do
          FileStore.set_adapter( "PStoreAdapter" )
        end

        it "should set adapter to PStoreAdapter" do
          FileStore.adapter.should == "PStoreAdapter"
        end

      end

      describe 'set file adapter with invalid adapter' do

        it "should raise AdapterNotFound error" do
          lambda {
           FileStore.set_adapter( "BlahAdapter" ) 
          }.should raise_error( FileStore::AdapterNotFound )
        end

      end

    end
    
    describe 'set_directory' do
      
      describe 'not called' do

        before( :each ) do
            FileUtils.should_receive( :mkdir_p ).with( "#{Dir.pwd}/datastore")
        end
        
        it "should be Dir.pwd/datastore" do
          FileStore.directory.should == "#{Dir.pwd}/datastore"
        end
      
      end
      
      describe 'with a valid directory' do
        
        before( :each ) do
          FileUtils.should_receive( :mkdir_p ).with( "/tmp/datastore")
          FileStore.set_directory( "/tmp" )
        end
        
        it "should be /tmp/datastore" do
          FileStore.directory.should == "/tmp/datastore"
        end
        
      end
      
      describe 'with an invalid directory' do
        
        it "should raise DirectoryNotFound" do
          lambda {
            FileStore.set_directory("blah/blah")
          }.should raise_error( FileStore::DirectoryNotFound )
        end
        
      end
      
    end
    
  end

end

require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../../../lib/aqua/store/file_store/file_system/adapter/yaml_adapter'
require File.dirname(__FILE__) + '/../../../lib/aqua/store/file_store/file_system/adapter/pstore_adapter'

MetaData = Aqua::Store::FileStore::MetaData unless defined?( MetaData )
describe MetaData do
  
  describe 'init' do
    
    describe 'with empty adapter' do
      
      it "should raise ArgumentError" do
        lambda {
          MetaData.init( "", Dir.pwd )
        }.should raise_error( ArgumentError )
      end
      
    end
    
    describe 'with empty directory' do
      
      it "should raise ArgumentError" do
        lambda {
          MetaData.init( "YAMLAdapter", "" )
        }.should raise_error( ArgumentError )
      end
      
    end
    
    describe 'with adapter and directory' do
      
      before( :each ) do
        @directory = "#{Dir.pwd}/datastore"
        @adapter   = YAMLAdapter.to_s
        FileUtils.mkdir_p( @directory )
      end
      
      after( :each ) do
        FileUtils.rm_rf( @directory )
      end
      
      describe 'with a fresh datastore directory, ie no resources' do
        
        before( :each ) do
          @meta_data = MetaData.init( @adapter, @directory )
        end
        
        it "should assign YAMLAdapter to _adapter" do
          @meta_data._adapter == YAMLAdapter
        end
        
        it "should assign @directory to @_directory" do
          @meta_data._directory.should == @directory
        end
        
        it "should have 0 metadatas" do
          @meta_data.metadatas.size.should == 0
        end
        
        describe 'for users metadata (which does not exist yet)' do
          
          before( :each ) do
            @user_meta_data = MetaData['users']
          end
          
          it "should have a last id of 0" do
            @user_meta_data.last_id.should == 0
          end
          
          it "should have a next id of 1" do
            @user_meta_data.next_id.should == 1
          end
          
          it "MetaData.next_id_for_class" do
            MetaData.next_id_for_class( "User" ).should == 1
          end
          
        end
        
      end
      
      describe 'with a datastore directory with "users" resource' do
        
        before( :each ) do
          @users_dir = "#{@directory}/users"
          FileUtils.mkdir_p( @users_dir )
          
          # create some sample records, without data...
          FileUtils.touch( "#{@users_dir}/1.yml" )
          FileUtils.touch( "#{@users_dir}/2.yml")
          
          @meta_data = MetaData.init( @adapter, @directory )
        end
        
        after( :each ) do
          FileUtils.rm_rf( @users_dir )
        end
        
        it "should assign YAMLAdapter to _adapter" do
          @meta_data._adapter == YAMLAdapter
        end
        
        it "should assign @directory to @_directory" do
          @meta_data._directory.should == @directory
        end
        
        it "should have 1 metadatas" do
          @meta_data.metadatas.size.should == 1
        end
        
        describe 'for users metadata' do
          
          before( :each ) do
            @user_meta_data = MetaData['users']
          end
          
          it "should have a last id of 2" do
            @user_meta_data.last_id.should == 2
          end
          
          it "should have a next id of 3" do
            @user_meta_data.next_id.should == 3
          end
          
          it "MetaData.next_id_for_class" do
            MetaData.next_id_for_class( "User" ).should == 3
          end
          
        end
        
        
      end
      
    end
    
  end
  
end
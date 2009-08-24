require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/aqua/store/file_store/file_store')
# place any file store spec specific setup here.

SANDBOX_DIR = File.dirname(__FILE__) + "/../../sandbox"
FileUtils.mkdir_p( SANDBOX_DIR )

at_exit do
  FileUtils.rm_rf( SANDBOX_DIR )
end
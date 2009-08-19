class User
  include Aqua::Tank
  
  attr_accessor :name, # An array of strings or a hash of strings 
    :created_at,# Time
    :dob,       # Date
    :username,  # simple string 
    :log,       # an Object 
    :password   # hidden value
  hide_attributes :password
  
  
  # convenience methods for inspection during testing
  # ------------------------------------------------- 
  # for testing what the pack looks like
  def to_store
    _pack
    __pack
  end
  
  def simple_classes
    _simple_classes
  end  
  
  # for testing whether attributse are hidden
  def visible_attr 
    _storable_attributes
  end

  # for testing class level configuration options
  def self.aquatic_options
    _aqua_opts
  end
         
end 
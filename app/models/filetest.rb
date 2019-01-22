class Filetest
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :wxcode,type:File
end

class Rotate
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :address,type:String
end

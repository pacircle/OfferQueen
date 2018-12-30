class SuperUser
  include Mongoid::Document
  field :_id,type: String
  field :name,type: String
  field :password,type :String
end

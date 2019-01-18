class Camp
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :order,type:Integer
  field :content,type:String
  field :description,type:String
  field :startTime,type:String
  field :endTime,type:String
  field :answers,type:Answer
  field :userList,type:Array


  ## 报名二维码
  field :signWay,type:String

end

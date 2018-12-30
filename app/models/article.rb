class Article
  include Mongoid::Document
  field :userId,type: String
  field :elite,type: Integer
  field :time,type: String
  field :title,type: String
  field :sub,type: String
  field :content,type: String
  field :agree,type: Integer
  field :commentList,type:Array
  field :avatarUrl,type:String
  field :nickName,type:String
end

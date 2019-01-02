class Article
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :userId,type: String
  field :elite,type: Integer
  field :time,type: String
  field :title,type: String
  field :sub,type: String
  field :content,type: String
  field :agree,type: Integer
  field :commentList,type:Array
  # field :avatarUrl,type:String
  field :readTime,type:Integer

  # has_many :comment, :class_name => "comment"
end

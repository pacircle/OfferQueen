class Answer
  include Mongoid::Document
  field :_id,type: String
  field :userId,type:String
  field :commentId,type:String
  field :content,type:String
end

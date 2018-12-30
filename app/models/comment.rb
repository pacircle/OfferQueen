class Comment
  include Mongoid::Document
  field :_id,type:String
  field :userId,type:String
  field :articleId,type: String
  field :time,type:String
  field :zone,type: String
  field :company,type:String
  field :post,type:String
  field :content,type:String
  field :answerList,type: Array
end

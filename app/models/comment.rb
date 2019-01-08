class Comment
  include Mongoid::Document
  # belongs_to :Article

  field :userId,type:String
  field :articleId,type: String
  field :time,type:String
  # field :zone,type: String
  # field :company,type:String
  # field :post,type:String
  field :content,type:String
  field :answerList,type: Array
end

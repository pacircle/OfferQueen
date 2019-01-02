class User
  include Mongoid::Document

  field :_id, type: String
  field :nickName,type: String
  field :avatarUrl,type:String
  field :city,type:String
  field :country,type:String
  field :gender,type: Integer
  field :language,type: String
  field :province,type: String
  field :authority,type: Integer
  field :inviteMember,type: Integer
  field :phone,type:Integer
  field :password,type:String
  # field :articleList,type:Array
  field :commentList,type:Array
  field :answerList,type:Array
  field :agreeList,type:Array
  field :collectList,type:Array
  field :readList,type:Array

end

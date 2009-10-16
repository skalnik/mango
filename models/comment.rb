class Comment
  include MongoMapper::Document
  
  key :author, String
  key :body, String
  timestamps!

  belongs_to :post
end
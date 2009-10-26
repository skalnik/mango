class Comment
  include MongoMapper::Document
  
  key :author, String
  key :body, String
  key :rendered, String
  timestamps!

  belongs_to :post
end
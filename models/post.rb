class Post
  include MongoMapper::Document
  
  key :title, String
  key :body, String
  key :rendered, String
  timestamps!

  has_many :comments
end
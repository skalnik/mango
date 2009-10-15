class Post
  include MongoMapper::Document
  
  key :title, String
  key :body, String
  timestamps!
end
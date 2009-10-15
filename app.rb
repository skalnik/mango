require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'haml'
Dir['models/*'].each { |model| require model }

configure do
  MongoMapper.connection = XGen::Mongo::Driver::Connection.new('localhost:26818')
  MongoMapper.database = 'mango'
end

get '/' do
  @posts = Post.find(:all)
  haml :"posts/index"
end

get '/posts/new' do
  haml :"posts/new"
end

post '/posts/new' do
  
end
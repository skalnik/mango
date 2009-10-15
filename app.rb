require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'haml'
Dir['models/*'].each { |model| require model }

configure do
  MongoMapper.connection = XGen::Mongo::Driver::Connection.new('localhost')
  MongoMapper.database = 'mango'
end

['/', '/posts'].each do |path|
  get path do
    @posts = Post.find(:all)
    haml :"posts/index"
  end
end

get '/posts/new' do
  haml :"posts/new"
end

post '/posts/new' do
  
end
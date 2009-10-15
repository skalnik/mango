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
    @posts = Post.find(:all, :order => 'created_at DESC')
    haml :"posts/index"
  end
end

get '/post/new' do
  haml :"posts/new"
end

post '/post/new' do
  post = Post.create({:title => params[:title], :body => params[:body]})
  redirect "/post/#{post.id}"
end

get '/post/:id' do
  @post = Post.find(:first, :conditions => { :_id => params[:id] })
  haml :"posts/show"
end
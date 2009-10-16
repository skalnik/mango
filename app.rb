require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'haml'
require 'yaml'
Dir['models/*'].each { |model| require model }

configure do
  config = YAML::load(File.open('config.yml'))
  MongoMapper.connection = XGen::Mongo::Driver::Connection.new(config['host'])
  MongoMapper.database = config['database']
end

['/', '/posts'].each do |path|
  get path do
    @posts = Post.all( :order => 'created_at DESC' )
    haml :"posts/index"
  end
end

get '/post/new' do
  haml :"posts/new"
end

post '/post/new' do
  post = Post.create(params)
  redirect "/post/#{post.id}"
end

get '/post/:id' do
  @post = Post.find(params[:id])
  haml :"posts/show"
end

post '/post/:post_id/comment/new' do
  post_id = params['post_id']
  params['post_id'] = nil
  comment = Post.find(post_id).comments << Comment.create(params)
  redirect "/post/#{post_id}"
end
require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'haml'
require 'yaml'
require 'RedCloth'
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

get '/posts/new' do
  haml :"posts/new"
end

post '/posts/new' do
  @post = Post.create(params)
  cleanup @post
  redirect "/post/#{@post.id}"
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  haml :"posts/show"
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  haml :"posts/edit"
end

put '/posts/:id' do
  @post = Post.find(params[:id])
  @post.update_attributes(params)
  cleanup @post
  redirect "/post/#{@post.id}"
end

post '/posts/:post_id/comments/new' do
  post_id = params['post_id']
  params['post_id'] = nil
  comment = Post.find(post_id).comments << Comment.create(params)
  redirect "/post/#{post_id}"
end

def cleanup(post)
  post.rendered = RedCloth.new(post.body).to_html
  post.tags_list = post.tags_list.gsub(/ /, "").downcase
  post.tags = post.tags_list.split(",")
  post.save!
end
require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'haml'
require 'yaml'
require 'RedCloth'
Dir['models/*'].each { |model| require model }

configure do
  config = YAML::load_file('config.yml')
  MongoMapper.connection = XGen::Mongo::Driver::Connection.new(config['database']['host'])
  MongoMapper.database = config['database']['name']
end

helpers do
  def cleanup(obj)
    obj.rendered = RedCloth.new(obj.body).to_html
    if obj.is_a?(Post)
      obj.tags_list = obj.tags_list.gsub(/ /, "").downcase
      obj.tags = obj.tags_list.split(",")
    end
    obj.save!
  end
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

post '/posts' do
  @post = Post.create(params)
  cleanup @post
  redirect "/posts/#{@post.id}"
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  haml :"posts/show"
end

delete '/posts/:id' do
  @post = Post.find(params[:id])
  @post.destroy
  redirect '/posts'
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  haml :"posts/edit"
end

put '/posts/:id' do
  @post = Post.find(params[:id])
  @post.update_attributes(params)
  cleanup @post
  redirect "/posts/#{@post.id}"
end

get '/posts/tags/:tags' do
  @tags = params[:tags]
  @tags = @tags.split(',') if @tags =~ /,/
  @posts = Post.all( :conditions => { :tags => @tags }, :order => 'created_at desc' )
  haml :"posts/tags"
end

post '/posts/:post_id/comments' do
  @comment = Comment.create(params)
  cleanup @comment
  redirect "/posts/#{params[:post_id]}"
end

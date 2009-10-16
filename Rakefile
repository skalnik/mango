# http://ozmm.org/posts/rake_start.html
namespace :mongodb do
  desc "Start MongoDB for development"
  task :start do
    mkdir_p "db"
    system "mongod --dbpath db/"
  end
end

namespace :mango do
  desc "Start Mango for development"
  task :start do
    system "shotgun app.rb"
  end
end

desc "Start everything."
multitask :start => [ 'mongodb:start', 'mango:start' ]
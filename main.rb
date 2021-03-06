require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

configure(:development){set :database, "sqlite3:test.sqlite3"}
enable :sessions


get "/" do
	@users = User.all
	@posts = Post.all
	@user = User.find(session[:user_id]) if session[:user_id]

	session[:visited] = "I'm here"

	erb :index
	
end

post '/videos' do 
	video = Video.new

	video.embed = params["embed"]
	video.user_id = current_user.id
end


post '/posts' do
	post = Post.new

	post.title = params["title"]
	post.body = params["body"]
	post.user_id = current_user.id


	post.save

	redirect "/"
end

get "/posts/delete/:id" do
	post = Post.find(params[:id])
	post.destroy

	redirect "/"
end

get "/posts/:id" do
	@post = Post.find(params[:id])

	erb :post_show
end

get '/posts/edit/:id' do
	@post = Post.find(params[:id])

	erb :post_edit	
end

post "/posts/edit/:id" do
	@post = Post.find(params[:id])

	@post.title = params[:title]
	@post.body = params[:body]

	@post.save

	redirect "posts/#{@post.id}"
end

get "posts/delete/:id" do
	Post.find(params[:id]).destroy

	redirect "/"


end

get "/users/details/:id" do
	@user = User.find(params[:id])
	erb :edit_profile

end


post "/users/details/:id" do
	user = User.find(params[:id])

	user.update_attributes(fname: params[:fname],
							:lname => params[:lname],
							:email => params[:email],
							:password => params[:password],
							:bio => params[:bio],
							:state => params[:state],
							:city => params[:city],
							:website => params[:website],
							:games => params[:games]
)

	flash[:notice] = "You've updated your account details!"

	redirect "/users/details/#{user.id}"
end

get "/sign_in" do
	erb :sign_in
end

post "/sessions/new" do
	user = User.where(email: params[:email]).first

	if user && user.password == params[:password] 
		session[:user_id] = user.id
		flash[:notice] = "You've successfully signed in!"
		redirect "/"
	else 
		flash[:notice] = "Try again!"
		redirect "/sign_in"
	end
	
end

get "/sign-out" do
	session.clear
	flash[:notice] = "You've successfully signed out!"

	redirect "/"
end



get "/sign-up" do 
	erb :signup_form
end

post "/sign-up" do

	@user = User.create(fname: params["first_name"], lname: params["last_name"], email: params["email_add"], password: params["password"])


	redirect "/sign_in"
end

get "/users/delete/:id" do
	session.clear
	post = User.find(params[:id]).posts.destroy_all
	user = User.find(params[:id]).destroy
	

	redirect "/"


end

get "/users/:id" do
	


	@posts = Post.all
	@user = User.find(params[:id])

	session[:visited] = "I'm here"

	erb :profile_page
end

def current_user
	@current_user = User.find(session[:user_id]) if session[:user_id]
end

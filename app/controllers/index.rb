get '/' do
  erb :index
end

get '/sign_in' do
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  session.delete(:request_token)

  current_user = User.find_or_create_by_username(
    :username => @access_token.params[:screen_name],
    :oauth_token => @access_token.token,
    :oauth_secret => @access_token.secret
    )

  session[:current_user_id] = current_user.id

  erb :index
end

post '/' do
  @current_user = User.find(session[:current_user_id])
  @twitter_username = @current_user.username
  tweet_delay = params[:tweet_delay].to_i

  @current_user.tweet(params[:tweet_text], tweet_delay)

  redirect to '/'
end

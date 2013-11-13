get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
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
  puts "DELAY: #{tweet_delay}"
  # @tweet = @current_user.tweets.create(:tweet_text => params[:tweet_text])
  # @tweet = Tweet.create(:tweet_text => params[:tweet_text], :user_id => @current_user.id)

  # puts "TWEET TEXT IN POST: #{params[:tweet_text]}"

  @current_user.tweet(params[:tweet_text], tweet_delay)

  # twitter_user = Twitter::Client.new(
  #   :oauth_token => User.find(session[:current_user_id]).oauth_token,
  #   :oauth_token_secret => User.find(session[:current_user_id]).oauth_secret
  # )

  # twitter_user.update(params[:tweet_text])

  redirect to '/'
end

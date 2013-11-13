class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status, delay_in_mins=0)
    tweet = tweets.create!(:tweet_text => status)
    if delay_in_mins > 0
      TweetWorker.perform_in(delay_in_mins.minutes, tweet.id)
    else
      TweetWorker.perform_async(tweet.id)
    end
  end
end

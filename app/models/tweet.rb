class Tweet
  attr_accessor :contents, :user_id, :score, :tweet_html

  def initialize(contents, user_id, tweet_html)
    @contents = contents
    @user_id = user_id
    @tweet_html = tweet_html
  end
end

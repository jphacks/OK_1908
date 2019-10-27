class MorphemesController < ApplicationController
  def analysis(sentence)
    body = {"app_id": ENV['GOO_APP_ID'],
            "request_id": "record001",
            "sentence": sentence,
            "info_filter": "form"
    }

    uri = URI('https://labs.goo.ne.jp/api/morph')
    @res = Net::HTTP.post_form(uri, body)
    JSON.parse(@res.body)["word_list"]
  end

  def scoring(tweet_text, tweets)
    if tweet_text.nil?
      return tweets
    end
    tweet_text_list = analysis(tweet_text).flatten
    tweet_text_list.split(mark).each_with_index do |tweet, i|
      tweets[i].score = Posinega.where(word: tweet).sum(:score) if tweets[i].present?
    end
    tweets
  end

  def search
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET'] 
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    @tweets = []
    tweet_text = ""
    since_id = nil
    if params[:keyword].present?
      tweets = client.search(params[:keyword], count: 250, result_type: "recent", exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(250).each do |tw|
        tweet_text << tw.full_text + mark
        tweet = Tweet.new(tw.full_text, tw.user.name)
        @tweets << tweet
      end
      @tweets = scoring(tweet_text, @tweets)
    end  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tweets } # jsonを指定した場合、jsonフォーマットで返す
    end
  end

  private
  def mark
    '*'*10
  end
end

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

  def scoring(tweet)
    word_list = analysis(tweet)
    sum_score = 0
    word_list.each do |sentence|
      sentence.each do |word|
        sum_score += Posinega.find_by(word: word).score
      end
    end
  end

  def search
    # @sentence = params[:sentence]
    # @word_list = analysis(@sentence)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET'] 
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    @tweets = []
    since_id = nil
    if params[:keyword].present?
      tweets = client.search(params[:keyword], count: 1, result_type: "recent", exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(1).each do |tw|
        score = scoring(tw.full_text)
        tweet = Tweet.new(tw.full_text, tw.user.name, score)
        @tweets << tweet
      end
    end  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tweets } # jsonを指定した場合、jsonフォーマットで返す
    end
  end
end

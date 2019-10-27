class MorphemesController < ApplicationController

  require 'open-uri'

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
    tweet_text_list = analysis(tweet_text).flatten
    tweet_text_list.split(mark).each_with_index do |tweet, i|
      tweets[i].score = Posinega.where(word: tweet).sum(:score) if tweets[i].present?
    end
    tweets
  end

  def get_tweet_html(tweet_url)
    '<blockquote class="twitter-tweet"><a href="'+tweet_url+'?ref_src=twsrc%5Etfw"></a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>'
  end

  def search
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    get_tweet_num = 250
    @tweets = []
    tweet_text = ""
    since_id = nil
    if params[:keyword].present?
      tweets = client.search(params[:keyword], count: get_tweet_num, result_type: "recent", exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(get_tweet_num).each do |tw|
        @tweet_html = get_tweet_html(tw.url.to_s)
        tweet_text << tw.full_text + mark
        tweet = Tweet.new(tw.full_text, tw.user.name,@tweet_html)
        @tweets << tweet
      end
      @tweets = scoring(tweet_text, @tweets)
      @tweets.sort_by! { |tweet| tweet.score }
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

  def search_user_age(user_id)
    search_url = URI.escape("https://twitter.com/#{user_id}")
    doc = setup_doc(search_url)
    doc.xpath('//*[contains(@class, "ProfileHeaderCard-birthdateText u-dir")]').children
  end

  def setup_doc(url)
    charset = 'utf-8'
    html = open(url) { |f| f.read }
    doc = Nokogiri::HTML.parse(html, nil, charset)
    # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
    doc.search('br').each { |n| n.replace("\n") }
    doc
  end
end

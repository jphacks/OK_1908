class MorphemesController < ApplicationController
  require 'open-uri'

  def analysis
    sentence = params[:sentence]

    body = {"app_id": ENV['GOO_APP_ID'],
            "request_id": "record001",
            "sentence": sentence,
            "info_filter": "form"
    }

    uri = URI('https://labs.goo.ne.jp/api/morph')
    @res = Net::HTTP.post_form(uri, body)
    @doc = search_user_age('kohei252')
  end

  def post_goo
  end

  private

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

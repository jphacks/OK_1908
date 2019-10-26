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

  def search
    @sentence = params[:sentence]
    @word_list = analysis(@sentence)
  end
  
end

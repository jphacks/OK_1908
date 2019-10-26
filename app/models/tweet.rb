class Tweet
  attr_accessor :contents, :user_id, :pn_score

  def initialize(contents, user_id, pn_score)
    @contents = contents
    @user_id = user_id
    @pn_score = pn_score
  end
end

class Tweet
  attr_accessor :contents, :user_id, :score

  def initialize(contents, user_id)
    @contents = contents
    @user_id = user_id
  end
end

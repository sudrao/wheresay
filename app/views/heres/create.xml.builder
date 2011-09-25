xml.page do
  xml.title("WhereSay")
  xml.link(here_path(:only_path => false))
  xml.description("Tweets near #{@location[:lng]}, #{@location[:lat]}")
  xml.content do
    for tweet in @tweets
      xml.text(tweet.text)
    end
  end
end

      
  
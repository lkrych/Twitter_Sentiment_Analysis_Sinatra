helpers do
    def mine_tweets(username,client,analyzer)
        tweets = client.search("to:#{username}", result_type: "recent").take(50).collect 
        sentiment_hash = {}
        tweet_hash = {:positive => [], :negative => [], :neutral => []}
        tweets.each do |tweet|
            score = analyzer.analyze(tweet.text)
            if score > 0.0
                if sentiment_hash["Positive"].nil?
                    sentiment_hash["Positive"] = 1
                else
                    sentiment_hash["Positive"] = sentiment_hash["Positive"] + 1
                    tweet_hash[:positive] << [tweet.text, tweet.created_at]
                end
            elsif score < 0.0
                if sentiment_hash["Negative"].nil?
                    sentiment_hash["Negative"] = 1
                else
                    sentiment_hash["Negative"] = sentiment_hash["Negative"] + 1
                    tweet_hash[:negative] << [tweet.text, tweet.created_at]
                end
            else
                if sentiment_hash["Neutral"].nil?
                    sentiment_hash["Neutral"] = 1
                else
                    sentiment_hash["Neutral"] = sentiment_hash["Neutral"] + 1
                    tweet_hash[:neutral] << [tweet.text, tweet.created_at]
                end
            
            end
        end
        return sentiment_hash, tweet_hash
    end
end
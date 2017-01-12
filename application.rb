require 'sinatra'
require 'chartkick'
require_relative 'analyzer.rb'


######twitter code####################
require 'twitter'
require_relative 'analyzer.rb'

def open_sentiment(path)
    f = File.readlines(path).each do |line|
        line.chomp!
    end
    
    f.delete_if {|word| word.include? ";"}
    
    f
end

@positives = open_sentiment("positive-words.txt")
@negatives = open_sentiment("negative-words.txt")

#init twitter api access
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "EcstdOfq0Al0EVBVI3C2mG5tq"
  config.consumer_secret     = "dUwumNNQUP8yqly3dQItmMoLYR5Fz1FJmpC17oDQS5tTlwWtE0"
  config.access_token        = "723897631781474304-DGnlYkTKEslcyXugGUi9OV3Bc8jtUMh"
  config.access_token_secret = "J4VQqXOTN4sOCr9w2ilpq7vfH63e2r8CetNR8lqUWrbi7"
end

#instantiate analyzer
analyzer = Analyzer.new(@positives,@negatives)

def mine_tweets(username,client,analyzer)
    tweets = client.search("to:#{username}", result_type: "recent").take(50).collect 
    sentiment_hash = {}
    tweets.each do |tweet|
        score = analyzer.analyze(tweet.text)
        if score > 0.0
            if sentiment_hash["Positive"].nil?
                sentiment_hash["Positive"] = 1
            else
                sentiment_hash["Positive"] = sentiment_hash["Positive"] + 1
            end
        elsif score < 0.0
            if sentiment_hash["Negative"].nil?
                sentiment_hash["Negative"] = 1
            else
                sentiment_hash["Negative"] = sentiment_hash["Negative"] + 1
            end
        else
            if sentiment_hash["Neutral"].nil?
                sentiment_hash["Neutral"] = 1
            else
                sentiment_hash["Neutral"] = sentiment_hash["Neutral"] + 1
            end
        
        end
    end
    return sentiment_hash
end
##########Server code################


get '/' do
    haml :index
end

get '/search' do
    @user_name = params[:screen_name]
    @sentiment_hash = mine_tweets(@user_name,client,analyzer)
    @profile_pic = client.user(@user_name).profile_image_url.to_s
    
    haml :search
end

ash = mine_tweets("ashvalejohn", client, analyzer)

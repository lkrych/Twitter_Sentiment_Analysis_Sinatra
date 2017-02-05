require 'sinatra'
require 'chartkick'
require_relative 'analyzer.rb'
require_relative 'helpers/helper'


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


##########Server code################


get '/' do
    @sample_pics = []
    @sample_names = ["@kanyewest", "@realdonaldtrump", "@big_ben_clock", "@SenWarren" ]
    @sample_names.inject(@sample_pics) {|arr, sample_name| arr << client.user(sample_name).profile_image_url.to_s}
    @sample_hash = {}
    @sample_names.each_with_index do |name,index|
        @sample_hash[name] = @sample_pics[index]
    end
    @url = "search?screen_name="
    haml :index
    
end

get '/search' do
    @user_name = params[:screen_name]
    @sentiment_hash, @tweet_hash = mine_tweets(@user_name,client,analyzer)
    @profile_pic = client.user(@user_name).profile_image_url.to_s
    puts @tweet_hash
    
    haml :search
end


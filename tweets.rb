require 'colorize'
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

#command line input
if ARGV.length != 1 #handle invalid input
  puts "Usage: ruby tweets.rb username"
  return
end

#init twitter api access
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "EcstdOfq0Al0EVBVI3C2mG5tq"
  config.consumer_secret     = "dUwumNNQUP8yqly3dQItmMoLYR5Fz1FJmpC17oDQS5tTlwWtE0"
  config.access_token        = "723897631781474304-DGnlYkTKEslcyXugGUi9OV3Bc8jtUMh"
  config.access_token_secret = "J4VQqXOTN4sOCr9w2ilpq7vfH63e2r8CetNR8lqUWrbi7"
end

tweets = client.search("to:#{ARGV[0]}", result_type: "recent").take(50).collect 
  



#instantiate analyzer
analyzer = Analyzer.new(@positives,@negatives)

score = 0
#analyze tweets
tweets.each do |tweet|
    score += analyzer.analyze(tweet.text)
end

puts "the score is #{score}."
if score > 0.0
    puts ":)".green
else if score < 0.0
    puts ":(".red
else
    puts ";[".yellow
end
end
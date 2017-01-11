require 'colorize'
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
  puts "Usage: ruby smile.rb word"
  return
end

#instantiate analyzer
analyzer = Analyzer.new(@positives,@negatives)

#analyze tweets
score = analyzer.analyze(ARGV[0].chomp)

if score > 0.0
    puts ":)".green
else if score < 0.0
    puts ":(".red
else
    puts ";[".yellow
end
end

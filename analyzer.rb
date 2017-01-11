class Analyzer
    
    def initialize(positives,negatives)
        @positives = positives
        @negatives = negatives
    end
    
    def analyze(phrase)
        phrase_arr = phrase.split(" ")
        phrase_arr.inject(0){|score,word| score += scr_sentiment(word)}
    end
    
    private
    
    
    def scr_sentiment(word)
        if @positives.include? word
            return 1
        elsif @negatives.include? word
            return -1
        else
            return 0
        end
    end
end

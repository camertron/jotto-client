class Guess
  attr_accessor :word, :count

  def self.from_hash(hash)
    guess = Guess.new
    guess.word = hash["word"]
    guess.count = hash["count"]
    guess
  end
end
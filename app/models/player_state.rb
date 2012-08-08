class PlayerState
  attr_accessor :name, :word, :board, :guesses

  def self.from_hash(hash)
    ps = PlayerState.new
    ps.name = hash["name"]
    ps.word = hash["word"]
    ps.board = AlphabetBoard.from_s(hash["board"])
    ps.guesses = hash["guesses"].map { |guess| Guess.from_hash(guess) }
    ps
  end
end
class AlphabetBoard
  ASCII_BASE = 65
  attr_accessor :letters

  def self.from_s(str)
    board = AlphabetBoard.new
    board.letters = str.split(" ").map do |letter_with_state|
      letter, state = letter_with_state.split("")
      letter_obj = Letter.new
      letter_obj.letter = letter
      letter_obj.state = case state
        when "o" then
          Letter::States::CIRCLED
        when "-" then
          Letter::States::UNDECORATED
        when "x" then
          Letter::States::CROSSED_OUT
      end
      letter_obj
    end
    board
  end

  def letter_for_char(char)
    @letters[char.upcase.ord - ASCII_BASE]
  end

  def to_s
    @letters.map do |letter_obj|
      indicator =  case letter_obj.state
        when Letter::States::CIRCLED
          "o"
        when Letter::States::UNDECORATED
          "-"
        when Letter::States::CROSSED_OUT
          "x"
      end

      "#{letter_obj.letter}#{indicator}"
    end.join(" ")
  end
end
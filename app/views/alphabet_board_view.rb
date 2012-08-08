class AlphabetBoardView < UIView
  LETTERS_PER_LINE = 8
  LETTER_WIDTH = LETTER_HEIGHT = 40
  attr_accessor :delegate

  def initWithFrame(frame)
    super

    @letters = (65..90).to_a.map(&:chr).each_slice(LETTERS_PER_LINE).each_with_index.map do |letter_chunk, chunk_index|
      start_x = (frame.last.first / 2) - ((letter_chunk.size * LETTER_WIDTH) / 2)
      letter_chunk.each_with_index.map do |letter, letter_index|
        letter_frame = [[start_x + (LETTER_WIDTH * letter_index), (LETTER_HEIGHT * chunk_index)], [LETTER_WIDTH, LETTER_HEIGHT]]
        letter_view = LetterView.alloc.initWithFrame(letter_frame, andLetter:letter)
        letter_view.delegate = self
        letter_view
      end
    end.flatten

    @letters.each { |letter_view| addSubview(letter_view) }
    self
  end

  def letter(letter, didStateChange:state)
    delegate.alphabet_board(self, didLetterStateChange:letter)
  end

  def refresh
    @letters.each_with_index do |letter_view, index|
      letter_view.state = GameList.current.player.board.letters[index].state
    end
  end

  private

  def drawRect(rect)
    UIColor.whiteColor.set
    UIBezierPath.bezierPathWithRect(rect).fill
  end
end
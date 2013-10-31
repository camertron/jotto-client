class AlphabetBoardView < UIView
  LETTERS_PER_LINE = 8
  LETTER_WIDTH = LETTER_HEIGHT = 40
  RESET_BTN_WIDTH = 90
  RESET_BTN_HEIGHT = 25
  PADDING = 16

  attr_accessor :delegate

  def initWithFrame(frame)
    super

    @letters = init_letters
    @letters.each { |letter_view| addSubview(letter_view) }

    init_reset_button

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

  def reset
    Messaging.show_confirm_message(
      "Reset Board", "Are you sure you want to reset your board?", {
        :yes => lambda do
          GameList.current.player.board.reset
          refresh
        end
      }
    )
  end

  private

  def init_letters
    (65..90).to_a.map(&:chr).each_slice(LETTERS_PER_LINE).each_with_index.flat_map do |letter_chunk, chunk_index|
      start_x = (frame.size.width / 2) - ((letter_chunk.size * LETTER_WIDTH) / 2)
      letter_chunk.each_with_index.map do |letter, letter_index|
        letter_frame = CGRectMake(start_x + (LETTER_WIDTH * letter_index), LETTER_HEIGHT * chunk_index, LETTER_WIDTH, LETTER_HEIGHT)
        letter_view = LetterView.alloc.initWithFrame(letter_frame, andLetter:letter)
        letter_view.delegate = self
        letter_view
      end
    end
  end

  def init_reset_button
    @reset_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @reset_btn.frame = reset_btn_bounds
    @reset_btn.setTitle('Reset', forState:UIControlStateNormal)
    @reset_btn.setTitle('Reset', forState:UIControlStateSelected)
    @reset_btn.addTarget(self, action:'reset', forControlEvents:UIControlEventTouchUpInside)
    addSubview(@reset_btn)
  end

  def reset_btn_bounds
    CGRectMake(
      bounds.size.width - (RESET_BTN_WIDTH + PADDING),
      bounds.size.height - (RESET_BTN_HEIGHT + PADDING),
      RESET_BTN_WIDTH,
      RESET_BTN_HEIGHT
    )
  end

  def drawRect(rect)
    UIColor.whiteColor.set
    UIBezierPath.bezierPathWithRect(rect).fill
  end
end
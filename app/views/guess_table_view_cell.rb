class GuessTableViewCell < UITableViewCell
  attr_accessor :word, :count
  PADDING = 0

  def drawRect(rect)
    font = UIFont.systemFontOfSize(22)
    x, y = 10, 8

    @guess.word.upcase.each_char do |char|
      letter_size = char.sizeWithFont(font)
      frame = CGRectMake(x, y, letter_size.width, letter_size.height)
      UIColor.blackColor.set
      char.drawAtPoint(CGPoint.new(x, y), withFont:font)

      UIColor.blueColor.set
      case GameList.current.player.board.letter_for_char(char).state
        when Letter::States::CIRCLED
          Drawing.get_circle_path(frame, PADDING).stroke
        when Letter::States::CROSSED_OUT
          Drawing.get_crossed_out_path(frame, PADDING).stroke
      end

      x += letter_size.width
    end

    UIColor.blackColor.set
    "(#{@guess.count})".drawAtPoint(CGPoint.new(x + 10, y), withFont:font)
  end

  def guess=(new_guess)
    @guess = new_guess
    setNeedsDisplay
  end
end
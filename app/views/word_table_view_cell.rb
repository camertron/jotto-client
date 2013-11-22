class WordTableViewCell < UITableViewCell
  def drawRect(rect)
    draw_each
  end

  def draw_each
    font = UIFont.systemFontOfSize(22)
    x, y = 10, 8

    @guess.word.upcase.each_char do |char|
      letter_size = char.sizeWithFont(font)
      frame = CGRectMake(x, y, letter_size.width, letter_size.height)
      UIColor.blackColor.set
      char.drawAtPoint(CGPoint.new(x, y), withFont:font)
      yield char, frame if block_given?
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
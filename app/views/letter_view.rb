class LetterView < UIView
  PADDING = 8

  attr_accessor :letter, :state
  attr_accessor :delegate

  def initWithFrame(frame, andLetter:letter)
    @letter = letter
    @state = Letter::States::UNDECORATED
    addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action:'tapped:'))
    initWithFrame(frame)
  end

  def state=(new_state)
    @state = new_state
    delegate.letter(self, didStateChange:@state)
    setNeedsDisplay
  end

  private

  def tapped(recognizer)
    @state = @state == (Letter::States.count - 1) ? 0 : @state + 1
    delegate.letter(self, didStateChange:@state)
    setNeedsDisplay
  end

  def drawRect(rect)
    UIColor.whiteColor.set
    UIBezierPath.bezierPathWithRect(rect).fill

    font = UIFont.systemFontOfSize(22)
    letter_size = @letter.sizeWithFont(font)
    x = (rect.size.width / 2) - (letter_size.width / 2)
    y = (rect.size.height / 2) - (letter_size.height / 2)

    UIColor.blackColor.set
    letter.drawAtPoint(CGPoint.new(x, y), withFont:font)

    UIColor.blueColor.set

    case @state
      when Letter::States::CROSSED_OUT
        Drawing.get_crossed_out_path(rect, PADDING).stroke
      when Letter::States::CIRCLED
        Drawing.get_circle_path(rect, PADDING).stroke
    end
  end
end
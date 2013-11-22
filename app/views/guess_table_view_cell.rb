class GuessTableViewCell < WordTableViewCell
  attr_accessor :word, :count
  PADDING = 0

  def drawRect(rect)
    draw_each do |char, frame|
      UIColor.blueColor.set
      case GameList.current.player.board.letter_for_char(char).state
        when Letter::States::CIRCLED
          Drawing.get_circle_path(frame, PADDING).stroke
        when Letter::States::CROSSED_OUT
          Drawing.get_crossed_out_path(frame, PADDING).stroke
      end
    end
  end
end
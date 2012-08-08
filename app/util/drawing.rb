module Drawing
  def self.get_circle_path(frame, padding)
    bp = UIBezierPath.bezierPathWithOvalInRect([[frame.origin.x + padding, frame.origin.y + padding], [frame.size.width - (padding * 2), frame.size.height - (padding * 2)]])
    bp.lineWidth = 2.0
    bp
  end

  def self.get_crossed_out_path(frame, padding)
    bp = UIBezierPath.alloc.init
    bp.lineWidth = 2.0
    bp.moveToPoint(CGPoint.new(frame.origin.x + padding, frame.origin.y + padding))
    bp.addLineToPoint(CGPoint.new(frame.origin.x + (frame.size.width - padding), frame.origin.y + (frame.size.height - padding)))
    bp.moveToPoint(CGPoint.new(frame.origin.x + (frame.size.width - padding), frame.origin.y + padding))
    bp.addLineToPoint(CGPoint.new(frame.origin.x + padding, frame.origin.y + (frame.size.height - padding)))
    bp
  end
end
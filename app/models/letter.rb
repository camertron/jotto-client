class Letter
  module States
    UNDECORATED = 0
    CROSSED_OUT = 1
    CIRCLED = 2

    def self.count
      3
    end
  end

  attr_accessor :letter, :state
end
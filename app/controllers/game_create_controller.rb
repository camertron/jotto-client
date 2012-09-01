class GameCreateController < UIViewController
  attr_accessor :delegate

  DEFAULT_PADDING = 5
  CONTROLS = [
    { :type => :text,
      :label => "Name",
      :name => :name_text_field,
      :placeholder => "Best game EVAR"
    }, {
      :type => :text,
      :label => "Your word",
      :name => :word_text_field,
      :placeholder => "UBLOO"
    }, {
      :type => :button,
      :label => "Create",
      :name => :create_game_button,
      :on_click => "create_game",
      :padding => [7, 0]  # top, bottom
    }
  ]

  def viewDidLoad
    setTitle("New Game")
    view.backgroundColor = UIColor.groupTableViewBackgroundColor
    init_controls
  end

  def init_controls
    y = DEFAULT_PADDING
    @controls = {}

    CONTROLS.each do |control|
      y += control[:padding][0] if control[:padding]

      ctl, height = case control[:type]
        when :text then add_text_control(control, y)
        when :button then add_button_control(control, y)
      end

      y += height + DEFAULT_PADDING
      @controls[control[:name]] = ctl

      y += control[:padding][1] if control[:padding]
    end
  end

  def add_text_control(control, y)
    height = 0
    height += add_label_control({ :text => control[:label] }, y)[1] if control[:label]

    bounds = [[10, y + height], [300, 35]]
    ctl = UITextField.alloc.initWithFrame(bounds)
    ctl.placeholder = control[:placeholder]
    ctl.borderStyle = UITextBorderStyleRoundedRect
    ctl.clearButtonMode = UITextFieldViewModeWhileEditing
    ctl.returnKeyType = UIReturnKeyDone
    ctl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    view.addSubview(ctl)
    [ctl, height + 35]
  end

  def add_button_control(control, y)
    bounds = [[10, y], [300, 35]]
    ctl = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    ctl.frame = bounds
    ctl.setTitle(control[:label], forState:UIControlStateNormal)
    ctl.setTitle(control[:label], forState:UIControlStateSelected)
    ctl.addTarget(self, action:control[:on_click], forControlEvents:UIControlEventTouchUpInside) if control[:on_click]
    view.addSubview(ctl)
    [ctl, 35]
  end

  def add_label_control(control, y)
    bounds = [[10, y], [300, 25]]
    ctl = UILabel.alloc.initWithFrame(bounds)
    ctl.backgroundColor = UIColor.clearColor
    ctl.font = UIFont.systemFontOfSize(14.0)
    ctl.text = control[:text]
    view.addSubview(ctl)
    [ctl, 25]
  end

  def create_game
    # send to server
    params = URL.build_params({
      :player => GameList.user_name,
      :word => @controls[:word_text_field].text,
      :game_name => @controls[:name_text_field].text
    })

    url = File.join(Game::ENDPOINT, "game", GameList.user_name, "create", "?#{params}")

    JottoRestClient.get(url, lambda do |response|
      Dispatch::Queue.main.sync do
        UIApplication.sharedApplication.keyWindow.rootViewController.popViewControllerAnimated(true)
        game = Game.from_hash(response.data["game"])
        delegate.gameCreated(self, didCreateGame:game)
      end
    end)
  end
end
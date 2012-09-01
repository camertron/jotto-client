class GuessSubmitController < UIViewController
  LABEL_BOUNDS = [[10, 10], [300, 25]]
  TEXT_VIEW_BOUNDS = [[10, 40], [300, 35]]
  SUBMIT_BTN_BOUNDS = [[10, 85], [300, 35]]

  attr_accessor :delegate

  def viewDidLoad
    setTitle("Guess")
    view.backgroundColor = UIColor.groupTableViewBackgroundColor
    self.init_label
    self.init_text_field
    self.init_submit_btn
    self.init_indicator
  end

  def init_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    @indicator_button = UIBarButtonItem.alloc.initWithCustomView(@indicator)
  end

  def init_label
    @label = UILabel.alloc.initWithFrame(LABEL_BOUNDS)
    @label.backgroundColor = UIColor.clearColor
    @label.font = UIFont.systemFontOfSize(14.0)
    @label.text = "Your guess:"
    view.addSubview(@label)
  end

  def init_text_field
    @text_field = UITextField.alloc.initWithFrame(TEXT_VIEW_BOUNDS)
    @text_field.placeholder = "GUESS"
    @text_field.borderStyle = UITextBorderStyleRoundedRect
    @text_field.clearButtonMode = UITextFieldViewModeWhileEditing
    @text_field.returnKeyType = UIReturnKeyDone
    @text_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    view.addSubview(@text_field)
  end

  def init_submit_btn
    @submit_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @submit_btn.frame = SUBMIT_BTN_BOUNDS
    @submit_btn.setTitle('Submit', forState:UIControlStateNormal)
    @submit_btn.setTitle('Submit', forState:UIControlStateSelected)
    @submit_btn.addTarget(self, action:'submit', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@submit_btn)
  end

  def submit
    if !@text_field.text || @text_field.text.strip == ""
      Messaging.show_error_message("Can't submit a blank guess.")
    else
      @submit_btn.enabled = false
      navigationItem.rightBarButtonItem = @indicator_button
      @indicator.startAnimating
      url = File.join(Game::ENDPOINT, "game", GameList.current.player.name, GameList.current.id.to_s, "guess", @text_field.text)
      puts url

      JottoRestClient.get(url, lambda do |response|
        Dispatch::Queue.main.sync do
          if response.succeeded?
            guess = Guess.from_hash(response.data["guess"])
            GameList.current.player.guesses << guess
            delegate.guessSubmit(self, didSubmitGuess:guess)

            @text_field.clearText
            UIApplication.sharedApplication.keyWindow.rootViewController.popViewControllerAnimated(true)
          elsif response.invalid?
            Messaging.show_message("Oops!", response.data["validation_messages"].first)
          else
            Messaging.show_error_message(response.data["message"])
          end

          @submit_btn.enabled = true
          navigationItem.rightBarButtonItem = nil
          @indicator.stopAnimating
        end
      end)
    end
  end
end
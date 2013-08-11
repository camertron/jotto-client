class GuessSubmitController < UIViewController
  TEXT_VIEW_BOUNDS = [[10, 10], [300, 35]]
  SUBMIT_BTN_BOUNDS = [[10, 55], [300, 35]]
  MY_WORD_BUTTON_BOUNDS = [[10, 95], [300, 35]]
  THONGLE_BOUNDS = [[60, 160], [200, 200]]

  attr_accessor :delegate

  def viewDidLoad
    init_text_field
    init_submit_btn
    init_indicator
    init_my_word_button
    init_thongle if GameList.thongle?
    setTitle("Guess");

    self.view.backgroundColor = UIColor.clearColor
    background_table_view = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStyleGrouped);
    self.view.addSubview(background_table_view)
    self.view.sendSubviewToBack(background_table_view)
  end

  def init_my_word_button
    @my_word_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @my_word_btn.frame = MY_WORD_BUTTON_BOUNDS
    @my_word_btn.setTitle('Tap to see your word', forState:UIControlStateNormal)
    @my_word_btn.setTitle('Tap to see your word', forState:UIControlStateSelected)
    @my_word_btn.addTarget(self, action:'see_word', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@my_word_btn)
  end

  def see_word
    Messaging.show_message("Your word", GameList.current.player.word.upcase)
  end

  def init_thongle
    @thongle_view = UIImageView.alloc.initWithFrame(THONGLE_BOUNDS)
    @thongle_view.setImage(UIImage.imageNamed("zombin101.png"))
    view.addSubview(@thongle_view)
  end

  def init_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    @indicator_button = UIBarButtonItem.alloc.initWithCustomView(@indicator)
  end

  def init_text_field
    @text_field = UITextField.alloc.initWithFrame(TEXT_VIEW_BOUNDS)
    @text_field.placeholder = "UBLOO"
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
    if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(@text_field.text)
      @submit_btn.enabled = false
      show_loading

      params = URL.build_params(:guess_text => @text_field.text || "")
      url = File.join(Game::ENDPOINT, "game", URL.encode(GameList.current.player.name), GameList.current.id.to_s, "guess", "?#{params}")

      JottoRestClient.get(url, lambda do |response|
        Dispatch::Queue.main.sync do
          if response.succeeded?
            guess = Guess.from_hash(response.data["guess"])
            player = PlayerState.from_hash(response.data["player"])
            finished = !!response.data["finished"]
            GameList.current.player.guesses << guess

            @text_field.clearText
            navigationController.popViewControllerAnimated(true)

            delegate.guessSubmit(self, didSubmitGuess:guess, forPlayer:player, gameIsFinished:finished)
          end

          @submit_btn.enabled = true
          hide_loading
        end
      end)
    else
      Messaging.show_message("Invalid Word", "According to Apple, '#{@text_field.text || ""}' is not a word.")
    end
  end

  def show_loading
    navigationItem.rightBarButtonItem = @indicator_button
    @indicator.startAnimating
  end

  def hide_loading
    navigationItem.rightBarButtonItem = nil
    @indicator.stopAnimating
  end
end
class GuessSubmitController < UIViewController
  include LayoutCreation

  attr_accessor :delegate

  def controls
    [
      { :type => :text,
        :name => :text_field,
        :placeholder => "UBLOO",
        :customizer => lambda do |control|
          control.clearButtonMode = UITextFieldViewModeWhileEditing
          control.returnKeyType = UIReturnKeyDone
          control.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
          control.setReturnKeyType(UIReturnKeyDone)
          control.delegate = self
          control.addTarget(
            self,
            action:"textFieldFinished:",
            forControlEvents:UIControlEventEditingDidEndOnExit
          )
        end
      }, {
        :type => :button,
        :label => 'Submit',
        :on_click => 'submit',
        :name => :submit_button
      }, {
        :type => :button,
        :label => 'Tap to see your word',
        :on_click => 'see_word',
        :name => :my_word_button
      }, {
        :type => :image,
        :file => 'zombin101.png',
        :width => 200,
        :height => 200,
        :name => :thongle_image
      }
    ]
  end

  def viewDidLoad
    @controls = layout(controls)
    init_indicator

    unless User.current_user.thongle?
      @controls[:thongle_image].hidden = true
    end

    self.view.backgroundColor = UIColor.clearColor
    background_table_view = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStyleGrouped)
    self.view.addSubview(background_table_view)
    self.view.sendSubviewToBack(background_table_view)
  end

  def viewWillAppear(animated)
    # show_won_label = GameList.current.player.won? ||
    #   (GameList.current.opponent.won? && GameList.current.status == "their_turn")
    # @won_label.hidden = true  # hide for now since logic is nuts and doesn't exist yet
  end

  def tabBarItem
    @tab_bar_item ||= begin
      image = UIImage.imageNamed("guess_tab_bar_item.png")
      UITabBarItem.alloc.initWithTitle("Guess", image:image, tag:0)
    end
  end

  # def init_won_label
  #   @won_label = UILabel.alloc.initWithFrame(WON_LABEL_BOUNDS)
  #   @won_label.backgroundColor = UIColor.clearColor
  #   @won_label.font = UIFont.systemFontOfSize(14.0)

  #   text = if GameList.current.player.won?
  #     "You won!"
  #   else
  #     "You lost :("
  #   end

  #   text << " Your word: #{GameList.current.player.word.upcase}"
  #   text << " Opponent's word: #{GameList.current.opponent.word.upcase}"

  #   @won_label.text = text
  #   view.addSubview(@won_label)
  # end

  def see_word
    Messaging.show_message("Your word", GameList.current.player.word.upcase)
  end

  def init_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    @indicator_button = UIBarButtonItem.alloc.initWithCustomView(@indicator)
  end

  def textFieldFinished(sender)
    # hide the keyboard
    sender.resignFirstResponder
  end

  def submit
    # if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(@text_field.text)
      @controls[:submit_button].enabled = false
      show_loading

      params = URL.build_params(:guess_text => @controls[:text_field].text || "")
      url = File.join(Game::ENDPOINT, "game", URL.encode(GameList.current.player.name), GameList.current.id.to_s, "guess", "?#{params}")

      JottoRestClient.get(url, lambda do |response|
        Dispatch::Queue.main.sync do
          if response.succeeded?
            guess = Guess.from_hash(response.data["guess"])
            player = PlayerState.from_hash(response.data["player"])
            finished = !!response.data["finished"]
            GameList.current.player.guesses << guess

            @controls[:text_field].clearText
            navigationController.popViewControllerAnimated(true)

            delegate.guessSubmit(self, didSubmitGuess:guess, forPlayer:player, gameIsFinished:finished)
          end

          @controls[:submit_button].enabled = true
          hide_loading
        end
      end)
    # else
    #   Messaging.show_message("Invalid Word", "According to Apple, '#{@text_field.text || ""}' is not a word.")
    # end
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

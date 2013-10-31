class DesktopController < UIViewController
  ALPHABET_BOARD_HEIGHT = 170

  def viewDidLoad
    init_guess_list
    init_alphabet_board
    init_guess_view
    init_guess_nav_button

    # GKLocalPlayer.localPlayer.authenticateWithCompletionHandler(lambda do |error|
    #   UIAlertView.alloc.initWithTitle("Message", message:"Complete!", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil).show
    # end)

    puts UserProperties.instance.username
  end

  def alphabet_board_frame
    gl = guess_list_frame
    CGRectMake(0, gl.size.height, 320, ALPHABET_BOARD_HEIGHT)
  end

  def guess_list_frame
    navigation_bar_size = UIApplication.sharedApplication.keyWindow.rootViewController.navigationBar.size
    bounds = UIScreen.mainScreen.applicationFrame

    CGRectMake(
      0, 0,
      bounds.size.width,
      bounds.size.height - (navigation_bar_size.height + ALPHABET_BOARD_HEIGHT)
    )
  end

  def init_guess_nav_button
    @guess_nav_button = UIBarButtonItem.alloc.initWithTitle("Guess", style:UIBarButtonItemStylePlain, target:self, action:'show_guess_view')
  	navigationItem.rightBarButtonItem = @guess_nav_button
  end

  def init_guess_view
    @submit_controller = GuessSubmitController.alloc.init
    @submit_controller.delegate = self
  end

  def show_guess_view
    GameList.current.save
    navigationController.pushViewController(@submit_controller, animated:true)
  end

  def init_alphabet_board
    @alphabet_board = AlphabetBoardView.alloc.initWithFrame(alphabet_board_frame)
    @alphabet_board.delegate = self
    view.backgroundColor = UIColor.whiteColor
    view.addSubview(@alphabet_board)
  end

  def init_guess_list
    @guess_list = UITableView.alloc.initWithFrame(guess_list_frame, style:UITableViewStylePlain)
    @guess_list.dataSource = self
    @guess_list.delegate = self
    view.addSubview(@guess_list)
  end

  def refresh
    setTitle(GameList.current.name)
    @alphabet_board.refresh
    @guess_list.reloadData
  end

  def alphabet_board(alphabet_board, didLetterStateChange:letter)
    GameList.current.player.board.letter_for_char(letter.letter).state = letter.state
    @guess_list.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    GameList.current.player.guesses.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = GuessTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.guess = GameList.current.player.guesses[indexPath.indexAtPosition(1)]
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @guess_list.deselectRowAtIndexPath(@guess_list.indexPathForSelectedRow, animated:true)
  end

  def guessSubmit(controller, didSubmitGuess:guess, forPlayer:player, gameIsFinished:finished)
    GameList.all[GameList::MY_TURN].reject! { |game| GameList.current.id == game.id }
    GameList.all[GameList::THEIR_TURN].reject! { |game| GameList.current.id == game.id }
    GameList.current.player = player

    if player.won?
      message = if finished
        "You guessed it!  Nice work."
      else
        "You guessed it!  Nice work.  Your opponent has one more chance."
      end

      Messaging.show_message("That's the Ticket", message)
      GameList.all[GameList::COMPLETE] << GameList.current unless GameList.all[GameList::COMPLETE].include?(GameList.current)
    else
      if finished
        Messaging.show_message("Game Over", "Alright that's all she wrote.  You bloo!")
        GameList.all[GameList::COMPLETE] << GameList.current unless GameList.all[GameList::COMPLETE].include?(GameList.current)
      else
        GameList.all[GameList::THEIR_TURN] << GameList.current unless GameList.all[GameList::THEIR_TURN].include?(GameList.current)
      end
    end

    refresh
  end
end
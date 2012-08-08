class DesktopController < UIViewController
  GUESS_LIST_FRAME = [[0, 0], [320, 250]]
  ALPHABET_BOARD_FRAME = [[0, 250], [320, 480]]

  def viewDidLoad
    self.init_alphabet_board
    self.init_guess_list
    self.init_guess_view
    self.init_guess_nav_button
    # GKLocalPlayer.localPlayer.authenticateWithCompletionHandler(lambda do |error|
    #   UIAlertView.alloc.initWithTitle("Message", message:"Complete!", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil).show
    # end)
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
    UIApplication.sharedApplication.keyWindow.rootViewController.pushViewController(@submit_controller, animated:true)
  end

  def init_alphabet_board
    @alphabet_board = AlphabetBoardView.alloc.initWithFrame(ALPHABET_BOARD_FRAME)
    @alphabet_board.delegate = self
    view.backgroundColor = UIColor.whiteColor
    view.addSubview(@alphabet_board)
  end

  def init_guess_list
    @guess_list = UITableView.alloc.initWithFrame(GUESS_LIST_FRAME, style:UITableViewStylePlain)
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

  def guessSubmit(controller, didSubmitGuess:guess)
    refresh
  end
end
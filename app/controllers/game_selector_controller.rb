class GameSelectorController < UITableViewController
  attr_reader :cells

  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
    setTitle("Games")

    init_action_sheet
    init_action_sheet_button
    init_indicator
    init_refresh_button
    init_desktop_view
    init_game_create_view
    init_join_view
  end

  def viewWillAppear(animated)
    update_list if GameList.all.size == 0
    view.deselectRowAtIndexPath(view.indexPathForSelectedRow, animated:animated)
    view.reloadData
    super
  end

  # this controller is the delegate for game_create_controller
  def gameCreated(controller, didCreateGame:game)
    GameList.all[GameList::NEW] << game
    view.reloadData
  end

  # private

  def init_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    @indicator_button = UIBarButtonItem.alloc.initWithCustomView(@indicator)
  end

  def init_action_sheet
    @action_sheet = UIActionSheet.alloc.initWithTitle(nil,
      delegate:self,
      cancelButtonTitle:"Cancel",
      destructiveButtonTitle:"Sign Out",
      otherButtonTitles:"New Game", nil
    )
  end

  def init_action_sheet_button
    @action_sheet_button = UIBarButtonItem.alloc.initWithTitle("•••", style:UIBarButtonItemStylePlain, target:self, action:'show_action_sheet')
    navigationItem.leftBarButtonItem = @action_sheet_button
  end

  def init_refresh_button
    @refresh_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action:'update_list')
    navigationItem.rightBarButtonItem = @refresh_button
  end

  def show_action_sheet
    @action_sheet.showInView(view)
  end

  def init_desktop_view
    @desktop = DesktopController.alloc.init
  end

  def init_game_create_view
    @game_create_controller = GameCreateController.alloc.init
    @game_create_controller.delegate = self
  end

  def init_join_view
    @join_view = GameJoinController.alloc.init
    @join_view.delegate = self
  end

  def update_list
    navigationItem.rightBarButtonItem = @indicator_button
    @indicator.startAnimating

    GameList.refresh(lambda do |game_list|
      Dispatch::Queue.main.sync do
        @indicator.stopAnimating
        navigationItem.rightBarButtonItem = @refresh_button
        view.reloadData
      end
    end)
  end

  def create_new_game
    navigationController.pushViewController(@game_create_controller, animated:true)
  end

  def sign_out
    User.current_user.sign_out
    GameList.all.clear
    navigationController.popViewControllerAnimated(true)
  end

  def gameJoined(controller, didJoinGame:joined_game)
    GameList.all[GameList::PENDING].reject! { |game| joined_game.id == game.id }
    GameList.all[GameList::THEIR_TURN] << joined_game
    view.reloadData
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    case buttonIndex
      when @action_sheet.firstOtherButtonIndex
        create_new_game
      when @action_sheet.destructiveButtonIndex
        sign_out
    end
  end

  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    if buttonIndex == 1  # user clicked "yes"
      navigationController.pushViewController(@join_view, animated:true)
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    identifier = "cell"
    cell = tableView.dequeueReusableCellWithIdentifier(identifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)

    text = GameList.all[indexPath.section][indexPath.row].name.dup
    if GameList.all[indexPath.section][indexPath.row].opponent
      text << " vs #{GameList.all[indexPath.section][indexPath.row].opponent}"
    end

    cell.textLabel.text = text
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    case indexPath.section
      when GameList::MY_TURN, GameList::THEIR_TURN, GameList::COMPLETE
        GameList.current = GameList.all[indexPath.section][indexPath.row]
        navigationController.pushViewController(@desktop, animated:true)
        @desktop.refresh
      when GameList::PENDING
        game = GameList.all[indexPath.section][indexPath.row]
        @join_view.game_id = game.id

        msg = UIAlertView.alloc.initWithTitle("Join Game?",
          message:"Are you sure you want to join this game?",
          delegate:self,
          cancelButtonTitle:"No",
          otherButtonTitles:nil
        )

        msg.addButtonWithTitle("Yes")
        msg.show
    end

    view.deselectRowAtIndexPath(indexPath, animated:true)
  end

  def tableView(tableView, titleForHeaderInSection:section)
    GameList::TITLES[section]
  end

  def numberOfSectionsInTableView(tableView)
    GameList::TITLES.size
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # current section may not have been retrieved from the server yet, return 0 if so
    GameList.all[section] ? GameList.all[section].size : 0
  end
end
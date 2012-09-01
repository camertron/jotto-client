class GameSelectorController < UITableViewController
  GAME_LIST_FRAME = [[0, 0], [320, 480]]
  attr_reader :cells

  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
    setTitle("Games")

    init_indicator
    init_new_game_button
    init_game_list
    init_refresh_button
    init_desktop_view
    init_game_create_view

    # update_list
  end

  def viewWillAppear(animated)
    @table_list_view.deselectRowAtIndexPath(@table_list_view.indexPathForSelectedRow, animated:animated)
    super
  end

  # this controller is the delegate for game_create_controller
  def gameCreated(controller, didCreateGame:game)
    GameList.all[GameList::PENDING] << game
    @table_list_view.reloadData
  end

  # private

  def init_game_list
    @table_list_view = UITableView.alloc.initWithFrame(GAME_LIST_FRAME, style:UITableViewStylePlain)
    @table_list_view.dataSource = self
    @table_list_view.delegate = self
    view.addSubview(@table_list_view)
  end

  def init_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    @indicator_button = UIBarButtonItem.alloc.initWithCustomView(@indicator)
  end

  def init_new_game_button
    @new_game_button = UIBarButtonItem.alloc.initWithTitle("New Game", style:UIBarButtonItemStylePlain, target:self, action:'create_new_game')
  	navigationItem.leftBarButtonItem = @new_game_button
  end

  def init_refresh_button
    @refresh_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action:'update_list')
    navigationItem.rightBarButtonItem = @refresh_button
  end

  def init_desktop_view
    @desktop = DesktopController.alloc.init
  end

  def init_game_create_view
    @game_create_controller = GameCreateController.alloc.init
    @game_create_controller.delegate = self
  end

  def update_list
    navigationItem.rightBarButtonItem = @indicator_button
    @indicator.startAnimating

    GameList.refresh(lambda do |game_list|
      Dispatch::Queue.main.sync do
        @indicator.stopAnimating
        navigationItem.rightBarButtonItem = @refresh_button
        @table_list_view.reloadData
        self.viewWillAppear(false)
      end
    end)
  end

  def create_new_game
    UIApplication.sharedApplication.keyWindow.rootViewController.pushViewController(@game_create_controller, animated:true)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    identifier = "cell"
    cell = tableView.dequeueReusableCellWithIdentifier(identifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
    cell.textLabel.text = GameList.all[indexPath.section][indexPath.row].name
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if [GameList::IN_PROGRESS, GameList::COMPLETE].include?(indexPath.section)
      GameList.current = GameList.all[indexPath.section][indexPath.row]
      UIApplication.sharedApplication.keyWindow.rootViewController.pushViewController(@desktop, animated:true)
      @desktop.refresh
    else
      @table_list_view.deselectRowAtIndexPath(indexPath, animated:true)
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    GameList::TITLES[section]
  end

  def numberOfSectionsInTableView(tableView)
    GameList::TITLES.size
  end

  def tableView(tableView, numberOfRowsInSection:section)
    count = GameList.all[section] ? GameList.all[section].size : 0
    count
  end
end
class GameSelectorController < UITableViewController
  GAME_LIST_FRAME = [[0, 0], [320, 480]]

  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
    setTitle("Games")

    init_indicator
    init_game_list
    init_refresh_button
    init_desktop_view

    update_list
  end

  def viewWillAppear(animated)
    @table_list_view.deselectRowAtIndexPath(@table_list_view.indexPathForSelectedRow, animated:animated)
    super
  end

  private

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

  def init_refresh_button
    @refresh_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action:'update_list')
  end

  def init_desktop_view
    @desktop = DesktopController.alloc.init
  end

  def update_list
    navigationItem.rightBarButtonItem = @indicator_button
    @indicator.startAnimating

    GameList.refresh(lambda do |game_list|
      Dispatch::Queue.main.sync do
        @table_list_view.reloadData
        @indicator.stopAnimating
        navigationItem.rightBarButtonItem = @refresh_button
      end
    end)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    GameList.all.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier:nil
    cell.textLabel.text = GameList.all[indexPath.indexAtPosition(0)].name
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    GameList.current = GameList.all[indexPath.indexAtPosition(0)]
    UIApplication.sharedApplication.keyWindow.rootViewController.pushViewController(@desktop, animated:true)
    @desktop.refresh
  end
end
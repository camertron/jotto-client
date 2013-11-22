class OpponentGuessListController < UITableViewController
  def viewDidLoad
  end

  def viewWillAppear(animated)
    view.reloadData
    super
  end

  def tabBarItem
    @tab_bar_item ||= begin
      image = UIImage.imageNamed("opponent_tab_bar_item.png")
      UITabBarItem.alloc.initWithTitle("Opponent", image:image, tag:0)
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    GameList.current.opponent.guesses.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = WordTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.guess = GameList.current.opponent.guesses[indexPath.indexAtPosition(1)]
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow, animated:true)
  end
end
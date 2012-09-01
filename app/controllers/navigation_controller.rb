class NavigationController < UINavigationController
  def viewDidLoad
    $root = GameSelectorController.alloc.init
    pushViewController($root, animated:false)
  end
end
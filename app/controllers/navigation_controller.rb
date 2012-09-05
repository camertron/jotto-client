class NavigationController < UINavigationController
  def viewDidLoad
    $root = LoginController.alloc.init
    pushViewController($root, animated:false)
  end
end
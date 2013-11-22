class ToolsController < UITabBarController
  def viewDidLoad
    init_submit_view
    init_opponent_guess_list_view

    setViewControllers([
      @submit_controller,
      @opponent_guess_list_controller
    ])
  end

  # attr_accessor can't be called from objective-c land
  def delegate=(delegate)
    @delegate = delegate
  end

  def delegate
    @delegate
  end

  def init_submit_view
    @submit_controller = GuessSubmitController.alloc.init
    @submit_controller.delegate = self
  end

  def init_opponent_guess_list_view
    @opponent_guess_list_controller = OpponentGuessListController.alloc.init
  end

  def guessSubmit(controller, didSubmitGuess:guess, forPlayer:player, gameIsFinished:finished)
    delegate.guessSubmit(controller, didSubmitGuess:guess, forPlayer:player, gameIsFinished:finished)
  end
end
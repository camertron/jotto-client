class GameJoinController < GuessSubmitController
  attr_accessor :game_id

  def viewDidLoad
    super
    setTitle("Your Word")
  end

  def init_my_word_button
    # override to avoid adding a "My word: " label
  end

  def submit
    show_loading

    params = URL.build_params(:word => @text_field.text || "")
    url = File.join(Game::ENDPOINT, "game", URL.encode(GameList.user_name), "join", @game_id.to_s, "?#{params}")

    JottoRestClient.get(url, lambda do |response|
      Dispatch::Queue.main.sync do
        if response.succeeded?
          @delegate.gameJoined(self, didJoinGame:Game.from_hash(response.data["game"]))
          navigationController.popViewControllerAnimated(true)
        end

        hide_loading
      end
    end)
  end
end
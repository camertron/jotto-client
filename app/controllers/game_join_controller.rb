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
    if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(@text_field.text)
      show_loading

      params = { :word => @text_field.text || "" }
      if PushNotifications.device_token
        params[:device_token] = PushNotifications.device_token
      end

      params = URL.build_params(params)
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
    else
      Messaging.show_message("Invalid Word", "According to Apple, '#{@text_field.text || ""}' is not a word.")
    end
  end
end
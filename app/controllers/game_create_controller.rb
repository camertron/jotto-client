class GameCreateController < UIViewController
  include LayoutCreation

  attr_accessor :delegate

  CONTROLS = [
    { :type => :text,
      :label => "Name",
      :name => :name_text_field,
      :placeholder => "Best game EVAR"
    }, {
      :type => :text,
      :label => "Your word",
      :name => :word_text_field,
      :placeholder => "UBLOO"
    }, {
      :type => :button,
      :label => "Create",
      :name => :create_game_button,
      :on_click => "create_game",
      :padding => [7, 0]  # top, bottom
    }
  ]

  def viewDidLoad
    setTitle("New Game")
    @controls = layout(CONTROLS)
    self.view.backgroundColor = UIColor.clearColor
    background_table_view = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStyleGrouped);
    self.view.addSubview(background_table_view)
    self.view.sendSubviewToBack(background_table_view)
  end

  def create_game
    # if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(@controls[:word_text_field].text)
      # send to server
      params = {
        :player => User.current_user.user_name,
        :word => @controls[:word_text_field].text || "",
        :game_name => @controls[:name_text_field].text || ""
      }

      if PushNotifications.device_token
        params[:device_token] = PushNotifications.device_token
      end

      params = URL.build_params(params)
      url = File.join(Game::ENDPOINT, "game", User.current_user.user_name, "create", "?#{params}")

      JottoRestClient.get(url, lambda do |response|
        Dispatch::Queue.main.sync do
          if response.succeeded?
            navigationController.popViewControllerAnimated(true)
            game = Game.from_hash(response.data["game"])
            delegate.gameCreated(self, didCreateGame:game)
            @controls[:word_text_field].clearText
            @controls[:name_text_field].clearText
          end
        end
      end)
    # else
    #   Messaging.show_message("Invalid Word", "According to Apple, '#{@controls[:word_text_field].text || ""}' is not a word.")
    # end
  end
end

class GameList < Array
  NEW = 0
  PENDING = 1
  MY_TURN = 2
  THEIR_TURN = 3
  COMPLETE = 4
  TITLES = { 0 => "New", 1 => "Pending", 2 => "My Turn", 3 => "Their Turn", 4 => "Complete" }

  class << self
    def all=(list)
      @all = list
    end

    def all
      @all ||= []
    end

    def refresh(callback)
      url = File.join(Game::ENDPOINT, "game", URL.encode(GameList.user_name), "list")
      JottoRestClient.get(url, lambda do |response|
        if response.succeeded?
          @all = []
          response.data["games"].each do |game_group|
            @all << game_group.map { |game_hash| Game.from_hash(game_hash) }
          end
        end

        callback.call(self)
      end)
    end

    def current
      @current
    end

    def current=(game)
      @current = game
    end

    def user_name
      @user_name
    end

    def user_name=(name)
      @user_name = name
    end

    def thongle?
      @user_name == "zombin101"
    end

    def add(new_game)
      @all << new_game
    end
  end
end
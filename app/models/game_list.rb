class GameList < Array
  PENDING = 0
  IN_PROGRESS = 1
  COMPLETE = 2
  TITLES = { 0 => "Pending", 1 => "In Progress", 2 => "Complete" }

  class << self
    def all=(list)
      @all = list
    end

    def all
      @all ||= []
    end

    def refresh(callback)
      JottoRestClient.get(File.join(Game::ENDPOINT, "game/#{GameList.user_name}/list"), lambda do |response|
        @all = []
        response.data["games"].each do |game_group|
          @all << game_group.map { |game_hash| Game.from_hash(game_hash) }
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
      #@user_name
      "camertron"
    end

    def user_name=(name)
      #@user_name = name
    end

    def add(new_game)
      @all << new_game
    end
  end
end
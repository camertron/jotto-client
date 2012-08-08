class GameList < Array
  class << self
    def all
      @all ||= []
    end

    def refresh(callback)
      JottoRestClient.get(File.join(Game::ENDPOINT, "game/#{GameList.user_name}/list"), lambda do |response|
        @all = response.data["games"].map { |game_hash| Game.from_hash(game_hash) }
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
  end
end
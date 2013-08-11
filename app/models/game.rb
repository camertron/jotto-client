class Game
  #ENDPOINT = "http://localhost:3001"
  ENDPOINT = "http://jotto-server.herokuapp.com"
  attr_accessor :name, :id, :status, :player, :opponent

  def self.from_hash(hash)
    game = Game.new
    game.name = hash["name"]
    game.id = hash["id"]
    game.status = hash["status"]
    game.opponent = hash["opponent"]
    game.player = PlayerState.from_hash(hash["player"]) if hash["player"]
    game
  end

  def save
    params = URL.build_params(:board => player.board.to_s)
    url = File.join(ENDPOINT, "game", player.name, id.to_s, "save", "?#{params}")
    JottoRestClient.get(url, lambda { |response| })
  end
end
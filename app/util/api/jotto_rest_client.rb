class JottoRestClient
  class << self
    def get(url_string, callback)
      AsyncRestClient.get_json(url_string, lambda do |data|
        callback.call(JottoResponse.new(data))
      end)
    end
  end
end

class JottoResponse
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def status_code
    @data["http_status"]
  end

  def status
    @data["text_status"].to_sym
  end

  def succeeded?
    @data["http_status"] == 200
  end

  def invalid?
    @data["http_status"] == 400
  end

  def failed?
    @data["http_status"] == 500
  end
end
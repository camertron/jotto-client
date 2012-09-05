class JottoRestClient
  class << self
    def get(url_string, callback)
      AsyncRestClient.get_json(url_string, lambda do |data|
        response = JottoResponse.new(data)

        if response.invalid?
          Dispatch::Queue.main.sync do
            Messaging.show_error_message(response.validation_messages.first)
          end
        elsif response.failed?
          Dispatch::Queue.main.sync do
            Messaging.show_error_message(response.message)
          end
        end

        callback.call(response)
      end)
    end
  end
end

class JottoResponse
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def message
    @data["message"]
  end

  def validation_messages
    @data["validation_messages"]
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
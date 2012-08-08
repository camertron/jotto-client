class AsyncRestClient
  class << self
    def get_string(url_string, callback)
      get(url_string, lambda do |data|
        callback.call(NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding))
      end)
    end

    def get_json(url_string, callback)
      get(url_string, lambda do |data|
        error = Pointer.new(:object)
        callback.call(NSJSONSerialization.JSONObjectWithData(data,
          options:NSJSONReadingMutableContainers,
          error:error))
      end)
    end

    private

    def get(url_string, callback)
      url = NSURL.URLWithString(url_string)
      request = NSURLRequest.requestWithURL(url)

      response = NSURLConnection.sendAsynchronousRequest(request, queue:queue, completionHandler:lambda do |response, data, error|
        callback.call(data)
      end)
    end

    def self.queue
      unless @queue
        @queue = NSOperationQueue.alloc.init
        @queue.setMaxConcurrentOperationCount(2)
      end
      @queue
    end
  end
end
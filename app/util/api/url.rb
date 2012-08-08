class URL
  class << self
    def encode(str)
      str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    end

    def build_params(params)
      params.map { |key, val| "#{encode(key)}=#{encode(val)}" }.join("&")
    end
  end
end
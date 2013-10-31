class UserProperties
  class << self
    def instance
      @instance ||= begin
        dict = NSDictionary.alloc.initWithContentsOfFile(path)
        new(dict)
      end
    end

    private

    def path
      @path = NSBundle.mainBundle.pathForResource("user", ofType:"plist")
    end
  end

  PROPERTIES = [:Username]

  PROPERTIES.each do |prop|
    attr_accessor prop.downcase
  end

  private

  def initialize(dict)
    PROPERTIES.each do |prop|
      send(:"#{prop.to_s.downcase}=", dict[prop.to_s])
    end
  end
end
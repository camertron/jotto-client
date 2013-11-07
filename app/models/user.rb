class User
  class << self
    attr_accessor :current_user

    def default_user_name
      user_defaults.objectForKey("user_name")
    end

    def sign_in(user_name)
      @current_user = new(user_name)
      user_defaults.setObject(current_user.user_name, forKey:"user_name")
      user_defaults.synchronize
      current_user
    end

    def user_defaults
      @user_defaults ||= NSUserDefaults.standardUserDefaults
    end
  end

  attr_reader :user_name

  def initialize(user_name)
    @user_name = user_name
  end

  def sign_out
    self.class.user_defaults.setObject(nil, forKey:"user_name")
    self.class.user_defaults.synchronize
    self.class.current_user = nil
  end

  def thongle?
    user_name == "zombin101"
  end
end
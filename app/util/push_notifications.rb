class PushNotifications
  class << self
    attr_accessor :device_token

    def handle_notification(userInfo)
      if message = userInfo.fetch('aps', {}).fetch('alert', nil)
        Messaging.show_message("Notification", message)
      end
    end
  end
end
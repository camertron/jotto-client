class Messaging
  class << self

    def show_error_message(message = "An error occurred.")
      UIAlertView.alloc.initWithTitle(
        "Error",
        message:message,
        delegate:nil,
        cancelButtonTitle:"Ok",
        otherButtonTitles:nil
      ).show
    end

    def show_message(title, message)
      UIAlertView.alloc.initWithTitle(
        title,
        message:message,
        delegate:nil,
        cancelButtonTitle:"Ok",
        otherButtonTitles:nil
      ).show
    end

    def message_handler_pool
      @message_handler_pool ||= []
    end

    def show_confirm_message(title, message, callbacks = {})
      yes_callback = callbacks[:yes]
      no_callback = callbacks[:no]
      handler = ConfirmMessageHandler.new(yes_callback, no_callback)
      message_handler_pool << handler

      alert = UIAlertView.alloc.init
      alert.title = title
      alert.message = message
      alert.delegate = handler

      alert.addButtonWithTitle("Yes")
      alert.addButtonWithTitle("No")
      alert.show
    end

  end

  ConfirmMessageHandler = Struct.new(:yes_callback, :no_callback) do
    def alertView(alertView, clickedButtonAtIndex:buttonIndex)
      if buttonIndex == 0
        yes_callback.call if yes_callback
      elsif buttonIndex == 1
        no_callback.call if no_callback
      end

      Messaging.message_handler_pool.delete(self)
    end
  end
end
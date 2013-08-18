class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = NavigationController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    PushNotifications.device_token = deviceToken.description.gsub(" ", "").gsub("<", "").gsub(">", "")
    puts PushNotifications.device_token
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    puts "Push notification registration failed: #{error.localizedDescription}"
  end

  def application(application, didReceiveRemoteNotification:userInfo)
    PushNotifications.handle_notification(userInfo)
  end
end

# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

ENV['JOTTO_ENV'] ||= "development"  # "distribution"

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Jotto'
  app.frameworks += %w(GameKit)
  app.icons = ["jotto-114.png", "jotto-58.png"]
  app.files_dependencies 'app/controllers/game_join_controller.rb' => 'app/controllers/guess_submit_controller.rb'
  app.provisioning_profile = "profiles/jotto.mobileprovision"
  app.identifier = "com.wildmouse.jotto"
  app.sdk_version = "9.2"
  app.deployment_target = "9.2"
  app.seed_id = "824577NP9X"
  app.entitlements['application-identifier'] = app.seed_id + '.' + app.identifier
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]
  app.entitlements['aps-environment'] = ENV['JOTTO_ENV']
  app.entitlements['get-task-allow'] = true

  app.info_plist['UILaunchImageFile'] = 'launch'

  if ENV['JOTTO_ENV'] == 'development'
    app.info_plist['NSAppTransportSecurity'] = {
      'NSAllowsArbitraryLoads' => true
    }
  end

  # app.info_plist['UIRequiredDeviceCapabilities'] = ['gamekit']
end

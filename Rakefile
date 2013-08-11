# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Jotto'
  app.frameworks += %w(GameKit)
  app.icons = ["jotto-114.png", "jotto-58.png"]
  app.files_dependencies 'app/controllers/game_join_controller.rb' => 'app/controllers/guess_submit_controller.rb'
  app.provisioning_profile = "jotto_kellye.mobileprovision"
  app.identifier = "com.wildmouse.jotto"
  app.sdk_version = "6.1"
  app.deployment_target = "6.1"

  # app.info_plist['UIRequiredDeviceCapabilities'] = ['gamekit']
end

class LoginController < UIViewController
  LOGIN_FIELD_BOUNDS = [[20, 155], [280, 35]]
  LOGIN_BUTTON_BOUNDS = [[20, 200], [280, 35]]

  def viewDidLoad
    init_game_selector_controller
    init_image_view
    init_login_field
    init_login_button
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:animated)
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:animated)

    if user_name = User.default_user_name
      @login_field.hidden = true
      @login_button.hidden = true
      do_login(user_name)
    else
      @login_field.hidden = false
      @login_button.hidden = false
    end

    super
  end

  def viewWillDisappear(animated)
    UIApplication.sharedApplication.setStatusBarHidden(false, animated:animated)
    navigationController.setNavigationBarHidden(false, animated:animated)
    super
  end

  def init_game_selector_controller
    @game_selector_controller = GameSelectorController.alloc.init
  end

  def init_image_view
    @image_view = UIImageView.alloc.init
    @image_view.contentMode = UIViewContentModeTopLeft | UIViewContentModeScaleToFill
    @image_view.image = UIImage.imageNamed(Imaging.appropriate_image_file("splash.png"))
    view.addSubview(@image_view)
  end

  def init_login_field
    @login_field = UITextField.alloc.initWithFrame(LOGIN_FIELD_BOUNDS)
    @login_field.placeholder = "Enter username ..."
    @login_field.borderStyle = UITextBorderStyleRoundedRect
    @login_field.clearButtonMode = UITextFieldViewModeWhileEditing
    @login_field.returnKeyType = UIReturnKeyDone
    @login_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    @login_field.autocapitalizationType = UITextAutocapitalizationTypeNone
    view.addSubview(@login_field)
  end

  def init_login_button
    @login_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @login_button.frame = LOGIN_BUTTON_BOUNDS
    @login_button.setTitle("Play!", forState:UIControlStateNormal)
    @login_button.setTitle("Play!", forState:UIControlStateSelected)
    @login_button.addTarget(self, action:"login_clicked", forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@login_button)
  end

  def do_login(user_name)
    User.sign_in(user_name)
    navigationController.pushViewController(@game_selector_controller, animated:true)
  end

  def login_clicked
    if @login_field.text && !@login_field.text.strip.empty?
      do_login(@login_field.text)
    else
      Messaging.show_message("Username Required", "Please enter a username to play.")
    end
  end
end
module LayoutCreation
  START_Y = 70
  PADDING = 5

  def layout(control_list)
    y = START_Y + PADDING

    control_list.each_with_object({}) do |control, ret|
      y += control[:padding][0] if control[:padding]

      ctl, height = case control[:type]
        when :text then add_text_control(control, y)
        when :button then add_button_control(control, y)
        when :image then add_image_control(control, y)
      end

      if control[:customizer]
        control[:customizer].call(ctl)
      end

      y += height + PADDING
      ret[control[:name]] = ctl

      y += control[:padding][1] if control[:padding]
    end
  end

  private

  def add_text_control(control, y)
    height = 0

    if control[:label]
      height += add_label_control({ :text => control[:label] }, y)[1]
    end

    bounds = [[10, y + height], [300, 35]]
    ctl = UITextField.alloc.initWithFrame(bounds)
    ctl.placeholder = control[:placeholder]
    ctl.borderStyle = UITextBorderStyleRoundedRect
    ctl.clearButtonMode = UITextFieldViewModeWhileEditing
    ctl.returnKeyType = UIReturnKeyDone
    ctl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    ctl.autocapitalizationType = UITextAutocapitalizationTypeNone
    view.addSubview(ctl)
    [ctl, height + 35]
  end

  def add_button_control(control, y)
    bounds = [[10, y], [300, 35]]
    ctl = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    ctl.frame = bounds
    ctl.setTitle(control[:label], forState:UIControlStateNormal)
    ctl.setTitle(control[:label], forState:UIControlStateSelected)
    ctl.addTarget(self, action:control[:on_click], forControlEvents:UIControlEventTouchUpInside) if control[:on_click]
    view.addSubview(ctl)
    [ctl, 35]
  end

  def add_label_control(control, y)
    bounds = [[10, y], [300, 25]]
    ctl = UILabel.alloc.initWithFrame(bounds)
    ctl.backgroundColor = UIColor.clearColor
    ctl.font = UIFont.systemFontOfSize(14.0)
    ctl.text = control[:text]
    view.addSubview(ctl)
    [ctl, 25]
  end

  def add_image_control(control, y)
    bounds = [[10, y], [control[:width], control[:height]]]
    ctl = UIImageView.alloc.initWithFrame(bounds)
    ctl.setImage(UIImage.imageNamed(control[:file]))
    view.addSubview(ctl)
    [ctl, control[:height]]
  end
end

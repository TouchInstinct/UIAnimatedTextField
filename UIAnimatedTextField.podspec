Pod::Spec.new do |s|
  s.name             = 'UIAnimatedTextField'
  s.version          = '0.1.10'
  s.summary          = 'UITextField with animated placeholder'
  s.description      = <<-DESC
                        This custom control can be used as a replacement for UITextField. It comes with 5 different text types: simple, password, url, tappable, date.
                       DESC
  s.homepage         = 'https://github.com/TouchInstinct/UIAnimatedTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = "Touch Instinct"
  s.source           = { :git => 'https://github.com/TouchInstinct/UIAnimatedTextField.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'UIAnimatedTextField/Source/**/*'
  s.frameworks = 'UIKit'
end

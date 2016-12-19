Pod::Spec.new do |s|
  s.name             = 'UIAnimatedTextField'
  s.version          = '0.1.4'
  s.summary          = 'UIAnimatedTextField'
  s.description      = <<-DESC
                        Animated text field
                       DESC
  s.homepage         = 'https://github.com/iznv/UIAnimatedTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ivan Zinovyev' => 'ivan.zinovyev@touchin.ru' }
  s.source           = { :git => 'https://github.com/iznv/UIAnimatedTextField.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'UIAnimatedTextField/Source/**/*'
  s.frameworks = 'UIKit'
end

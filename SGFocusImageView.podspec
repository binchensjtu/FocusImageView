
Pod::Spec.new do |s|

  s.name         = "SGFocusImageView"
  s.version      = "1.0.0"
  s.summary      = "a banner view that can scroll cycle."
  s.homepage     = "https://github.com/Starer/FocusImageView"
  s.license      = "BSD"
  s.author             = { "starer" => "tuple.star@gmail.com" }
  
  s.platform     = :ios, "5.0"
  s.ios.deployment_target = "5.0"
  s.source       = { :git => "https://github.com/Starer/FocusImageView.git", :tag => "1.0.0" }

  s.source_files = 'FocusImageView/SGFocus/*'

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

  s.requires_arc = true

end

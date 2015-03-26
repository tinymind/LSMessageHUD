Pod::Spec.new do |s|
  s.name     = 'LSMessageHUD'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'Easy to use and customizable messages/notifications/toasts HUD for iOS, supports simple strings or attributed strings.'
  s.homepage = 'https://github.com/tinymind/LSMessageHUD'
  s.author   = { "lslin" => "xappbox@gmail.com" }
  s.source   = { :git => 'https://github.com/tinymind/LSMessageHUD.git', :tag => s.version.to_s}
  s.platform = :ios, '7.0'
  s.requires_arc = true  
  
  s.source_files = 'Classes/*'
  s.frameworks = 'Foundation', 'UIKit'
end
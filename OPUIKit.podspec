Pod::Spec.new do |s|
  s.name     = 'OPUIKit'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  
  s.summary  = 'UIKit additions.'
  s.homepage = 'https://github.com/mbrandonw/OPUIKit'
  s.author   = { 'Brandon Williams' => 'brandon@opetopic.com' }
  s.source   = { :git => 'git@github.com:mbrandonw/OPUIKit.git' }
  
  s.source_files = 'OPUIKit/Source/**/*.{h,m}'
  
  s.frameworks = 'UIKit'
  
  s.dependency 'OPExtensionKit', :git => 'git@github.com:mbrandonw/OPExtensionKit.git'
  s.dependency 'OPQuartzKit', :git => 'git@github.com:mbrandonw/OPQuartzKit.git'
  
end
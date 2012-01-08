Pod::Spec.new do |s|
  s.name     = 'OPUIKit'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  
  s.summary  = 'UIKit additions.'
  s.homepage = 'https://brandonwilliams.beanstalkapp.com/opuikit'
  s.author   = { 'Brandon Williams' => 'brandon@opetopic.com' }
  s.source   = { :git => 'git@brandonwilliams.beanstalkapp.com:/opuikit.git' }
  
  s.source_files = 'Source/**/*.{h,m}'
  
  s.frameworks = 'UIKit'
  s.dependency 'BlocksKit', '~> 1.0.1'
  
  s.dependency 'OPExtensionKit', :git => 'git@brandonwilliams.beanstalkapp.com:/opextensionkit.git'
  
end
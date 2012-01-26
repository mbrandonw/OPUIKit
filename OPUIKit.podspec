Pod::Spec.new do |s|
  s.name     = 'OPUIKit'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  
  s.summary  = 'UIKit additions.'
  s.homepage = 'https://github.com/mbrandonw/OPUIKit'
  s.author   = { 'Brandon Williams' => 'brandon@opetopic.com' }
  s.source   = { :git => 'git@github.com:mbrandonw/OPUIKit.git' }
  
  s.source_files = 'OPUIKit/Source/**/*.{h,m}'
  s.resource     = 'OPUIKit/Source/**/*.{xib}'
  s.requires_arc = true
  
  s.frameworks = 'UIKit'
  
  s.dependency 'OPExtensionKit', :git => 'git@github.com:mbrandonw/OPExtensionKit.git'
  s.dependency 'OPQuartzKit', :git => 'git@github.com:mbrandonw/OPQuartzKit.git'
  s.dependency 'SDURLCache', '~> 1.2'
  s.dependency do |p|
    p.name     = 'AFNetworking'
    p.version  = '0.8.0'
    p.summary  = 'A delightful iOS and OS X networking framework'
    p.homepage = 'https://github.com/AFNetworking/AFNetworking'
    p.authors  = {'Mattt Thompson' => 'm@mattt.me', 'Scott Raymond' => 'sco@gowalla.com'}
    p.source   = { :git => 'https://github.com/AFNetworking/AFNetworking.git', :tag => '0.8.0' }  
    p.source_files = 'AFNetworking'
  end
  
end

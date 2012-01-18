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
  
  s.dependency do |m|
    m.name         = 'MAObjCRuntime'
    m.version      = '0.0.0'
    m.platform     = :ios
    m.source       = { :git => 'https://github.com/mikeash/MAObjCRuntime.git' }
    m.source_files = '{MARTNSObject,RTIvar,RTMethod,RTProperty,RTProtocol,RTUnregisteredClass}.{h,m}'
  end
end

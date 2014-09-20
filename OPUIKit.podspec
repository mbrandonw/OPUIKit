Pod::Spec.new do |spec|
  spec.name         = 'OPUIKit'
  spec.version      = '0.1.0'
  spec.license      = { type: 'BSD' }
  spec.homepage     = 'https://github.com/mbrandonw/OPUIKit'
  spec.authors      = { 'Brandon Williams' => 'mbw234@gmail.com' }
  spec.summary      = ''
  spec.source       = { :git => 'https://github.com/mbrandonw/OPUIKit.git' }
  spec.source_files = 'OPUIKit/Source/*.{h,m}'
  spec.resource     = 'OPUIKit/Source/**/*.{xib}'
  spec.requires_arc = true

  spec.frameworks = 'UIKit'

  spec.dependency 'OPExtensionKit'
  spec.dependency 'UIFont-Symbolset'
end

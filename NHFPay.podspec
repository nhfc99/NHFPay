Pod::Spec.new do |s|
  s.name         = "NHFPay"
  s.version      = "1.1.13"
  s.summary      = "微信、支付宝、银联、Apple Pay 4种支付方式的集合封装，仅仅用于方便使用"
  s.homepage     = "https://github.com/nhfc99/NHFPay.git"
  s.license      = "MIT"
  s.author       = {"nhfc99"=>"nhfc99@163.com"}
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = {:git => "https://github.com/nhfc99/NHFPay.git",:tag => s.version.to_s}
  s.requires_arc = true
  s.static_framework = true
  s.frameworks = 'QuartzCore','CoreData','PassKit','Security','CoreMotion','Foundation','UIKit','CoreGraphics','CoreText','CoreTelephony','SystemConfiguration','AlipaySDK'
  s.libraries = 'c++','z','sqlite3.0'

  s.dependency "AlipaySDK-iOS"
  s.dependency "WechatOpenSDK"

  s.public_header_files = 'NHFPay/Pay/NHFPay.h'

  s.subspec 'WechatObject' do |ss|
    ss.source_files = 'NHFPay/Pay/WechatObject/*.{h,m}'
    ss.public_header_files = 'NHFPay/Pay/WechatObject/*.h'
  end

  s.subspec 'AlipayObject' do |ss|
    ss.source_files = 'NHFPay/Pay/AlipayObject/*.{h,m}'
    ss.public_header_files = 'NHFPay/Pay/AlipayObject/*.h'
  end

  s.subspec 'applePaySDK' do |ss|
    ss.source_files = 'NHFPay/Pay/applePaySDK/**/*.{h,m}'
    ss.public_header_files = 'NHFPay/Pay/applePaySDK/**/*.h'
    ss.vendored_libraries = ['NHFPay/Pay/applePaySDK/libs/libUPAPayPlugin.a']
  end
end

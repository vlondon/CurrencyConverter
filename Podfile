source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

target 'CurrencyConverter' do
    use_frameworks!
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'
    pod 'SnapKit', '~> 3.0'
    pod 'Swinject', '~> 2.1.0'
    pod 'EVReflection/XML'
    pod 'VMScrollView'
end

target 'CurrencyConverterTests' do
    use_frameworks!
    pod 'Swinject', '~> 2.1.0'
    pod 'Quick', '~> 0.10.0'
    pod 'Nimble', '~> 5.1.1'
    pod 'Mockingjay', :git => 'https://github.com/kylef/Mockingjay.git'
    pod 'RxBlocking', '~> 3.0.1'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
         config.build_settings['SWIFT_VERSION'] = '3.2'
     end
 end
end
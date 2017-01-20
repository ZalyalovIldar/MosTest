# Uncomment the next line to define a global platform for your project
 platform :ios, '8.0'
 source 'https://github.com/CocoaPods/Specs.git'
 use_frameworks!

abstract_target 'Abstract' do 
    # Helpers
    pod 'FSHelpers+Swift', :git => 'https://github.com/fs/FSHelper.git'
    pod 'XCGLogger', :git => 'https://github.com/DaveWoodCom/XCGLogger.git', :branch => 'swift_3.0'

    # Libraries
    pod 'Realm'
    pod 'RealmSwift'
    pod 'Alamofire', '~> 4.0'
    pod 'ObjectMapper'
    pod 'SDWebImage'
    pod 'SVProgressHUD'

    target 'VK-MOS' do
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
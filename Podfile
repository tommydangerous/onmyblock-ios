platform :ios, '7.1'

source 'https://github.com/CocoaPods/Specs.git'

pod 'AFNetworking'
pod 'Facebook-iOS-SDK'
pod 'GoogleAnalytics-iOS-SDK', '3.0.3c'
pod 'IOSLinkedInAPI'
pod 'Mixpanel'
pod 'NewRelicAgent'
pod 'PayPal-iOS-SDK'
pod 'SDWebImage', '~> 3.6'

link_with 'OnMyBlock', 'OnMyBlock Tests'

post_install do |installer|
  installer.project.targets.each do |target|
    puts "#{target.name}"
  end
end

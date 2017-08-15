# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'OneNightBand' do






  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!


  # Pods for OneNightBand
pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'IQKeyboardManagerSwift'
pod 'JSQMessagesViewController'
pod "Player", "~> 0.2.0"
pod 'YouTubePlayer'
pod 'DropDown'
pod 'SwiftOverlays', '~> 3.0.0'
pod 'YNDropDownMenu'
pod 'FlexibleSteppedProgressBar'




  target 'OneNightBandTests' do
    inherit! :complete
    # Pods for testing
pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'IQKeyboardManagerSwift'
pod 'JSQMessagesViewController'
pod "Player", "~> 0.2.0"

pod 'YouTubePlayer'
pod 'DropDown'
pod 'SwiftOverlays', '~> 3.0.0'
pod 'YNDropDownMenu'
pod 'FlexibleSteppedProgressBar'

  end

  target 'OneNightBandUITests' do
    inherit! :complete
    # Pods for testing
pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'IQKeyboardManagerSwift'
pod 'JSQMessagesViewController'
pod "Player", "~> 0.2.0"
pod 'YouTubePlayer'
pod 'DropDown'
pod 'SwiftOverlays', '~> 3.0.0'
pod 'YNDropDownMenu'
pod 'FlexibleSteppedProgressBar'
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

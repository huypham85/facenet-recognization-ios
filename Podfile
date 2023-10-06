# Uncomment the next line to define a global platform for your project
$minimum_deployment_target = '13.0'
platform :ios, $minimum_deployment_target
  use_frameworks!
target 'ClassFaceAttendance' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  pod 'TensorFlow-experimental'
  pod 'FaceCropper'
  pod 'Alamofire'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'IQKeyboardManagerSwift'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'RealmSwift'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'ProgressHUD', '~> 13.7.2'
  pod 'SDWebImage'
  pod 'RxSwift'
  pod 'RxCocoa'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $minimum_deployment_target
    end
    
    # fix Code signing issues in Xcode 14
    # Xcode 13 used to automatically set CODE_SIGNING_ALLOWED to NO by default for resource bundles.
    # But that's no longer the case in Xcode 14.
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end

  end
end

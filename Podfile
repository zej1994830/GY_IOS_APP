# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'GY_app_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GY_app_ios
  pod 'Alamofire', '5.1.0' #网络请求库
  pod 'MJRefresh'          #下拉刷新
  pod 'SnapKit', '~> 5.0.0'           #自动布局库
  pod 'SnapKitExtend'
  pod 'MBProgressHUD'      #HUD指示器
  pod 'IQKeyboardManagerSwift'
  pod 'FSPagerView'
  pod 'JJException'  # 闪退保护
  pod 'JXSegmentedView', '~> 1.2.7'
  pod 'SDWebImage', '~> 5.0.6'
  pod 'SDWebImageFLPlugin', '~> 0.3.0'
  pod 'PINCache', '2.3'
  pod 'SwiftyJSON'
  pod 'HandyJSON'
  pod 'SwiftPopMenu'
  pod 'JJCollectionViewRoundFlowLayout_Swift'
  pod 'DGCharts'
  pod 'BRPickerView'
#  pod 'AAChartKit', :git => 'https://github.com/AAChartModel/AAChartKit.git'
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
  pod 'SpreadsheetView'
  pod 'OpenGLUtils', :path => '../openGL'
  pod "GCDWebServer", "~> 3.5.4"
  
  target 'GY_app_iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GY_app_iosUITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end


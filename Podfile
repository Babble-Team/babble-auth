DEPLOYMENT_TARGET_IOS = '13.0'

GOOGLESIGNIN_POD_VERSION = '6.1.0'
FIREBASE_POD_VERSION = '8.12.1'
FIREBASEAUTH_POD_VERSION = '8.12.0'

platform :ios, '13.0'
source 'https://cdn.cocoapods.org/'

use_frameworks!
inhibit_all_warnings!

def common_pods
  pod 'Firebase', FIREBASE_POD_VERSION
  pod 'FirebaseAuth', FIREBASEAUTH_POD_VERSION
  pod 'GoogleSignIn', GOOGLESIGNIN_POD_VERSION
end

target 'AuthSDK' do
   common_pods
end

target 'AuthSDKTests' do
    
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = DEPLOYMENT_TARGET_IOS
    end
  end
end

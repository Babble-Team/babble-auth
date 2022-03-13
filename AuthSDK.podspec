Pod::Spec.new do |spec|
    
    spec.name         = "AuthSDK"
    spec.version      = "0.0.1"
    spec.license      = { :type => 'All rights reserved', :file => 'README.md' }
    spec.homepage     = "https://github.com/Babble-Team/babble-auth"
    spec.authors      = { 'Krzysztof Łowiec' => 'cph.lowiec@gmail.com', 'Kornelia Bisewska' => 'bisewskakornelia@gmail.com' }
    spec.summary      = "Babble Auth SDK"
    spec.source       = { :git => 'git@github.com:Babble-Team/babble-auth.git', :tag => "#{spec.version}"  }
    spec.requires_arc = true

    spec.ios.deployment_target = '13.0'
    spec.swift_version = '5.0'

#     spec.dependency 'Firebase'
#     spec.dependency 'FirebaseAuth'
#     spec.dependency 'GoogleSignIn'

#     spec.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '
#         $(PODS_ROOT)/AuthSDK/Firebase 
#         $(PODS_ROOT)/AuthSDK/FirebaseAuth 
#         $(PODS_ROOT)/AuthSDK/GoogleSignIn 

#         $(PODS_TARGET_SRCROOT)/AuthSDK/Firebase
#         $(PODS_TARGET_SRCROOT)/AuthSDK/FirebaseAuth
#         $(PODS_TARGET_SRCROOT)/AuthSDK/GoogleSignIn'
#     }
    
    spec.source_files = 'AuthSDK/**/*.{swift}'

    spec.test_spec 'AuthSDKTests' do |test_spec|
        test_spec.frameworks = 'XCTest'
    end

end

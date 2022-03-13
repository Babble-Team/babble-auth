Pod::Spec.new do |spec|
    
    spec.name         = "AuthSDK"
    spec.version      = "0.0.1"
    spec.license      = { :type => 'All rights reserved', :file => 'README.md' }
    spec.homepage     = "https://github.com/Babble-Team/babble-auth"
    spec.authors      = { 'Krzysztof Łowiec' => 'cph.lowiec@gmail.com', 'Kornelia Bisewska' => 'bisewskakornelia@gmail.com' }
    spec.summary      = "Babble Auth SDK"
    spec.source       = { :git => 'git@github.com:Babble-Team/babble-auth.git', :tag => spec.version.to_s  }

    spec.ios.deployment_target = '13.0'
    spec.swift_version = '5.0'

    spec.dependency 'Firebase', '8.12.1'
    spec.dependency 'FirebaseAuth'
    spec.dependency 'GoogleSignIn', '6.1.0'
    
    spec.source_files = 'AuthSDK/sdk/Sources/**/*.{*.swift,swift}'

    spec.test_spec 'AuthSDKTests' do |test_spec|
        test_spec.frameworks = 'XCTest'
    end

end

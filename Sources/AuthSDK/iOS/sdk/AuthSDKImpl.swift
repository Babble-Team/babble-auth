//
//  AuthSDKImpl.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation
import Combine

public typealias CompletionPublisher = AnyPublisher<AuthState, AuthSDKError>

public final class AuthSDKImpl: AuthSDK {
    
    public static let shared: AuthSDK = AuthSDKImpl()
    
    // MARK: - Stored Properties
    
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    
    // MARK: - Initialization
    
    private init() {
        googleAuthService = GoogleAuthServiceImpl()
        appleAuthService = AppleAuthServiceImpl()
    }
    
    
    // MARK: - Methods
    
    public func configure() { }
    
}

// MARK: API

extension AuthSDKImpl {
    
    // MARK: - Methods
    
    /// Sign in the user with choosen auth provider.
    /// - Parameters:
    ///    - provider: The authorization provider. For the available providers, see `AuthProvider`.
    public func signIn(with provider: AuthProvider) -> CompletionPublisher {
        switch provider {
        case .google:
            return googleAuthService.showGoogleSignInView()
        case .apple:
            return appleAuthService.requestSignInFlow()
        }
    }
    
    /// Sign out the user for choosen auth provider.
    /// - Parameters:
    ///    - provider: The authorization provider. For the available providers, see `AuthProvider`.
    public func signOut(with provider: AuthProvider) {
        switch provider {
        case .google:
            return googleAuthService.signOut()
        case .apple:
            return appleAuthService.signOut()
        }
    }
    
    /// Restore recent sign in state for choosen auth provider.
    /// - Parameters:
    ///    - provider: The authorization provider. For the available providers, see `AuthProvider`.
    public func restoreSignInState(with provider: AuthProvider) -> CompletionPublisher {
        switch provider {
        case .google:
            return googleAuthService.restoreSignInState()
        default:
            break /// FIXME
        }
    }
    
}

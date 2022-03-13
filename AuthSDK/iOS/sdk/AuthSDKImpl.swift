//
//  AuthSDKImpl.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation

public typealias Completion = (Result<AuthState, AuthSDKError>) -> Void

public final class AuthSDKImpl: AuthSDK {
    
    // MARK: - Stored Properties
    
    private let googleAuthService: GoogleAuthService
    
    
    // MARK: - Initialization
    
    init() {
        googleAuthService = GoogleAuthServiceImpl()
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
    func signIn(
        with provider: AuthProvider,
        completion: @escaping Completion
    ) {
        switch provider {
        case .google:
            googleAuthService.requestSignInFlow(completion: completion)
        }
    }
    
    /// Sign out the user for choosen auth provider.
    /// - Parameters:
    ///    - provider: The authorization provider. For the available providers, see `AuthProvider`.
    func signOut(
        with provider: AuthProvider,
        completion: @escaping Completion
    ) {
        switch provider {
        case .google:
            googleAuthService.signOut()
        }
    }
    
    /// Restore recent sign in state for choosen auth provider.
    /// - Parameters:
    ///    - provider: The authorization provider. For the available providers, see `AuthProvider`.
    func restoreSignInState(
        with provider: AuthProvider,
        completion: @escaping Completion
    ) {
        switch provider {
        case .google:
            googleAuthService.restoreSignInState(completion: completion)
        }
    }
    
}

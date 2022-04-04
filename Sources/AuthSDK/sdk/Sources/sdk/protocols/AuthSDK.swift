//
//  AuthSDK.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation

public protocol AuthSDK {
    
    func signIn(with provider: AuthProvider) -> CompletionPublisher
    func signOut(with provider: AuthProvider)
    func restoreSignInState(with provider: AuthProvider) -> CompletionPublisher
    
}

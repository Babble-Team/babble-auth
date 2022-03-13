//
//  AuthSDK.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation

public protocol AuthSDK {
    
    func signIn(with provider: AuthProvider, completion: @escaping Completion)
    func signOut(with provider: AuthProvider, completion: @escaping Completion)
    func restoreSignInState(with provider: AuthProvider, completion: @escaping Completion)
    
}

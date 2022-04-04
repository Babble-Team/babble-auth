//
//  GoogleAuthService.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import Combine

protocol GoogleAuthService {
    
    func showGoogleSignInView() -> CompletionPublisher
    func restoreSignInState() -> CompletionPublisher
    func signOut()
    
    func isURLRequestHandled(for url: URL) -> Bool
    
}

final class GoogleAuthServiceImpl: GoogleAuthService {
    
    // MARK: - Stored Properties
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Methods
    
    func showGoogleSignInView() -> CompletionPublisher {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return Fail(error: .unableToRetrieveFirebaseClientID)
                .eraseToAnyPublisher()
        }
        
        let configuration = GIDConfiguration(clientID: clientID)
        guard let topViewController = UIApplication.shared.windows.last?.rootViewController else {
            return Fail(error: .unableToFindRootViewController)
                .eraseToAnyPublisher()
        }
        
        return Future<AuthState, AuthSDKError> { promise in
            GIDSignIn.sharedInstance.signIn(
                with: configuration,
                presenting: topViewController
            ) { (user, error) in
                guard
                    error == nil,
                    let authUser = user
                else {
                    promise(.failure(.unableToAuthenticate))
                    return
                }
                
                self.authenticateWithFirebase(forUser: authUser) {
                    switch $0 {
                    case let .success(state):
                        promise(.success(state))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isURLRequestHandled(for url: URL) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
        return handled
    }
    
    func restoreSignInState() -> CompletionPublisher {
        return Future<AuthState, AuthSDKError> { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { (user, error) in
                if (error != nil || user == nil) {
                    promise(.success(.notAuthorized))
                } else {
                    promise(.success(.authorized))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    private func authenticateWithFirebase(
        forUser user: GIDGoogleUser,
        completion: @escaping (Result<AuthState, AuthSDKError>) -> Void
    ) {
        guard let idToken = user.authentication.idToken else {
            completion(.failure(.unableToRetrieveIdToken))
            return
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.authentication.accessToken
        )
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let uID = authResult?.user.uid else {
                completion(.failure(.unableToAthenticateWithThisMethod))
                return
            }
            
            // FIXME: Async check in database, if user exist
            if true == true {
                // TODO: Update user token and id if needed (?)
                completion(.success(.authorized))
                return
            } else {
                guard
                    let user = authResult?.user,
                    let email = user.email
                else {
                    completion(.failure(.unableToAuthorize))
                    return
                }
                
                let token = "" // TODO: Get local user token

                let localUser = User(
                    id: uID,
                    email: email,
                    name: user.displayName,
                    token: token
                )

                // TODO: Create user in database
                completion(.success(.authorized))
            }
        }
    }
    
}

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

protocol GoogleAuthService {
    
    func requestSignInFlow(completion: @escaping Completion)
    func restoreSignInState(completion: @escaping Completion)
    func signOut()
    
    func isURLRequestHandled(for url: URL) -> Bool
    
}

final class GoogleAuthServiceImpl: GoogleAuthService {
    
    // MARK: - Stored Properties
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Methods
    
    func requestSignInFlow(completion: @escaping Completion) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(.unableToRetrieveFirebaseClientID))
            return
        }
        
        let configuration = GIDConfiguration(clientID: clientID)
        guard let topViewController = UIApplication.shared.windows.last?.rootViewController else {
            completion(.failure(.unableToFindRootViewController))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(
            with: configuration,
            presenting: topViewController
        ) { (user, error) in
            guard
                error == nil,
                let authUser = user
            else {
                completion(.failure(.unableToAuthenticate))
                return
            }
            
            self.authenticateWithFirebase(
                forUser: authUser,
                completion: completion
            )
        }
    }
    
    func isURLRequestHandled(for url: URL) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
        return handled
    }
    
    func restoreSignInState(completion: @escaping Completion) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { (user, error) in
            completion(.success((error != nil || user == nil) ? .notAuthorized : .authorized))
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    private func authenticateWithFirebase(
        forUser user: GIDGoogleUser,
        completion: @escaping Completion
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

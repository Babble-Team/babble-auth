//
//  AppleAuthService.swift
//  AuthSDK
//
//  Created by Kornelia Bisewska on 13/05/2022.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Firebase
import Combine

protocol AppleAuthService {
    
    func requestSignInFlow() -> AnyPublisher<AuthState, AuthSDKError>
    func signOut()
    
}

final class AppleAuthServiceImpl: NSObject, AppleAuthService {
    
    // MARK: - Stored Properties
        
    private let appleIDCredential = PassthroughSubject<ASAuthorizationAppleIDCredential, Never>()
    private var currentNonce: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    func requestSignInFlow() -> CompletionPublisher {
        performRequest()
        
        return Future<AuthState, AuthSDKError> { promise in
            self.appleIDCredential.first()
                .sink {
                    self.authenticateWithFirebase(credential: $0)
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                return
                            case let .failure(error):
                                promise(.failure(error))
                            }
                        } receiveValue: {
                            promise(.success($0))
                        }
                        .store(in: &self.cancellables)
                }
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
        } catch let error {
            debugPrint(error)
        }
    }
    
    private func performRequest() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    private func authenticateWithFirebase(
        credential: ASAuthorizationAppleIDCredential
    ) -> CompletionPublisher {
        guard
            let idToken = credential.identityToken,
            let idTokenString = String(data: idToken, encoding: .utf8)
        else {
            return Fail(error: .unableToRetrieveIdToken)
                .eraseToAnyPublisher()
        }

        let authCredential = OAuthProvider.credential(
            withProviderID: Constants.providerID,
            idToken: idTokenString,
            rawNonce: currentNonce
        )

        return Future<AuthState, AuthSDKError> { promise in
            Auth.auth().signIn(with: authCredential) { (authResult, error) in
                guard let uID = authResult?.user.uid else {
                    promise(.failure(.unableToAuthenticateWithThisMethod))
                    return
                }
                
                // FIXME: Async check in database, if user exist
                if true == true {
                    // TODO: Update user token and id if needed (?)
                    promise(.success(.authorized))
                    return
                } else {
                    guard
                        let user = authResult?.user,
                        let email = user.email
                    else {
                        promise(.failure(.unableToAuthorize))
                        return
                    }
                    
                    let token = "" // TODO: Get local user token
                    
                    let localUser = User(
                        id: uID,
                        email: email,
                        name: nil,
                        token: token
                    )
                    
                    // TODO: Create user in database
                    promise(.success(.authorized))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthServiceImpl: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            self.appleIDCredential.send(appleIDCredential)
        default:
            break
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        debugPrint(error)
    }
    
}

// MARK: - Supporting Methods

private extension AppleAuthServiceImpl {
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData
            .compactMap {
                String(format: "%02x", $0)
            }
            .joined()

        return hashString
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: [Character] = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
        )
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
}

private enum Constants {
    
    static let providerID = "apple.com"
    
}

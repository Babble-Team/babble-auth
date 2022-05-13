//
//  AppleSignInButton.swift
//  AuthSDK
//
//  Created by Kornelia Bisewska on 13/05/2022.
//

import AuthenticationServices
import Combine

public final class AppleSignInButton: ASAuthorizationAppleIDButton {
    
    // MARK: - Stored Properties
    
    private let onFinish: (AuthState) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization

    public init(
        style: ASAuthorizationAppleIDButton.Style,
        onFinish: @escaping (AuthState) -> Void
    ) {
        self.onFinish = onFinish
        
        super.init(
            type: .signIn,
            style: style
        )
        
        self.addTarget(
            self,
            action: #selector(onTapGesture(_:)),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc private func onTapGesture(_ sender: UIControl) {
        AuthSDKImpl.shared.signIn(with: .apple)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: return
                case .failure(let error):
                    debugPrint("AppleSignInButton: Error \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] in
                self?.onFinish($0)
            }
            .store(in: &cancellables)
    }

}

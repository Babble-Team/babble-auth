//
//  GoogleSignInButton.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import GoogleSignIn
import Combine

public final class GoogleSignInButton: GIDSignInButton {
    
    // MARK: - Stored Properties
    
    private let onFinish: (AuthState) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization

    public init(
        size: CGSize,
        onFinish: @escaping (AuthState) -> Void
    ) {
        self.onFinish = onFinish
        
        super.init(frame: CGRect(
            origin: .zero,
            size: size
        ))
        
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
        AuthSDKImpl.shared.signIn(with: .google)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: return
                case let .failure(error):
                    debugPrint("GoogleSignInButton: Error \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] in
                self?.onFinish($0)
            }
            .store(in: &cancellables)
    }

}

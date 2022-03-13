//
//  GoogleSignInButton.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import GoogleSignIn

public final class GoogleSignInButton: GIDSignInButton {
    
    // MARK: - Stored Properties
    
    private let completion: Completion
    
    // MARK: - Initialization

    public init(
        size: CGSize,
        completion: @escaping Completion
    ) {
        self.completion = completion
        
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
        AuthSDKImpl().signIn(
            with: .google,
            completion: completion
        )
    }

}

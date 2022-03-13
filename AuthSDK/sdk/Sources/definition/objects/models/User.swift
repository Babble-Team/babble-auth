//
//  User.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation

struct User: Codable {
    
    let id: String
    let email: String
    let name: String?
    let token: String?
    
}

//
//  AuthSDKError.swift
//  AuthSDK
//
//  Created by Krzysztof Łowiec on 12/03/2022.
//

import Foundation

public enum AuthSDKError: Error {
    
    case unableToRetrieveFirebaseClientID
    case unableToFindRootViewController
    case unableToRetrieveIdToken
    
    case unableToAuthenticate
    case unableToAthenticateWithThisMethod
    case unableToAuthorize
    
}

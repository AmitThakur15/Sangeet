//
//  AuthResponse.swift
//  Sangeet
//
//  Created by Aniket Kumar Thakur on 17/10/21.
//

import Foundation
import UIKit

struct AuthResponse:Codable {
    
    let accesstoken:String
    let expiresin: Int
    let refreshtoken:String?
    let scope: String
    let tokentype:String
    
    enum CodingKeys: String, CodingKey {
        case accesstoken = "access_token"
        case expiresin = "expires_in"
        case refreshtoken = "refresh_token"
        case scope = "scope"
        case tokentype = "token_type"
        
    }
}


//
//  AuthUser.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import Foundation

struct AuthUser {
    let id: String
    let email: String?
    let fullName: String?
    let identityToken: Data?
}

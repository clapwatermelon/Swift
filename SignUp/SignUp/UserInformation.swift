//
//  UserInformation.swift
//  SignUp
//
//  Created by 박수현 on 12/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import Foundation

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var telephone: String?
    var birth: String?
    
}

//
//  User.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/9/22.
//

import Foundation

class User {
    
    var username: String
    var email: String
    
    var password: String
    
    var id: Int = 1 // talk to Dante about how he wants to do user ID's
    
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.password = password
        self.email = email
    }
    
}

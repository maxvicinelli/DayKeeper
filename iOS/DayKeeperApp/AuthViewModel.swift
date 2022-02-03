//
//  AuthViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/2/22.
//

// Created w/ help from https://cocoacasts.com/networking-essentials-how-to-implement-basic-authentication-in-swift

import Foundation


final class AuthenticationModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var authenticated = false
    
   
    
    // @Published var signingIn = false
    
    func attemptSignIn() -> Bool {
        
        if username == "Maxvicinelli" && password == "password" {
            authenticated = true
            return true
        } else {
            authenticated = false
            return false
        }
    }
    
}

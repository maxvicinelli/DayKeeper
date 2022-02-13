//
//  RealmSetup.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/13/22.
//

import Foundation
import RealmSwift
import SwiftUI

let app: RealmSwift.App? = RealmSwift.App(id: RealmAppId)

func registerUser(vm: AuthenticationModel, onCompletion: @escaping (Bool) -> Void) {
    let client = app!.emailPasswordAuth
    
    client.registerUser(email: vm.email, password: vm.password) { (error) in
        guard error == nil else {
            print("Failed to register: \(error!.localizedDescription)")
            onCompletion(false)
            return
        }
        // Registering just registers. You can now log in.
        print("Successfully registered user.")
        onCompletion(true)
    }
    
    
}

func signIn(vm: AuthenticationModel, onCompletion: @escaping (Bool) -> Void) {
    let app = app
    print("signing in")
    app!.login(credentials: Credentials.emailPassword(email: vm.username, password: vm.password)) { result in
        //isLoggingIn = false
        if case let .failure(error) = result {
            print("Failed to log in: \(error.localizedDescription)")
            onCompletion(false)
            // Set error to observed property so it can be displayed
            //self.error = error
        }
        // Other views are observing the app and will detect
        // that the currentUser has changed. Nothing more to do here.
        print("Logged in")
        onCompletion(true)
    }
}

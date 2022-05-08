//
//  SettingsViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/2/22.
//

import Foundation
import RealmSwift

final class SettingsViewModel: ObservableObject {
    
//    @Published var childUUID: UUID = UUID()
    @Published var childEmail: String = ""
    @Published var childPassword: String = ""
    
    @Published var authorized: Bool = false
    
    // CHILD SETTINGS
    
    @Published var canCreateEvents = false
    @Published var canLocationTrack = true
    
    
    func attemptAuthorization() {
        let authModel = AuthenticationModel()
        authModel.email = childEmail
        authModel.password = childPassword
        let app = app
        let parent = app?.currentUser
        var child = app?.currentUser
        signIn(vm: authModel, onCompletion: { (success) in
            if (success) {
                print("child login successful ")
                self.authorized = true
                child = app?.currentUser
                app?.switch(to: parent!)
                updateConnectedUsers(newUUID: child!.id, onCompletion: { (failure) in
                    print("failed with ", failure)
                })
            } else {
                print("epic fail")
                self.authorized = false
                
            }
        })
    }
    
    func addChild() {
        print("add child")
        attemptAuthorization()
    }
}

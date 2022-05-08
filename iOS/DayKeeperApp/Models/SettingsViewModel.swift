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
    
    func addChild() {
        if let app = app {
            let parentUser = app.currentUser
            print(app.currentUser?.id)
            signIn(vm: self, onCompletion: { (success) in
                if (success) {
                    print("win!")
                    print(app.currentUser?.id)
                    let childUser = app.currentUser
                    app.switch(to: parentUser!)
//                    updateConnectedUsers(newUUID: String, onCompletion: @escaping (Bool) -> Void)
                    updateConnectedUsers(newUUID: childUser?.id!, onCompletion: { (failure) in
                        print("failed with ", failure)
                    })
//                    updateConnectedUsers(newUUID: childUser?.id!,
//                                         onCompletion: { (failure) in
//                                        print("failed with ", failure)})
                    print(app.currentUser?.id)
                } else {
                    print("epic fail")
                }
            })
        }
    }
}

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
    app!.login(credentials: Credentials.emailPassword(email: vm.email, password: vm.password)) { result in
        //isLoggingIn = false
        if case let .failure(error) = result {
            print("Failed to log in: \(error.localizedDescription)")
            onCompletion(false)
            return
        }
        // Other views are observing the app and will detect
        // that the currentUser has changed. Nothing more to do here.
        print("Logged in")
        onCompletion(true)
    }
}

func logoutUser(vm: AuthenticationModel, onCompletion: @escaping (Bool) -> Void) {
    let app = app
    app!.currentUser!.logOut { (error) in
        if error == nil {
            vm.unauthenticate()
            vm.cancelSettings()
            onCompletion(false)
        } else {
            print("Failed to log out: \(String(describing: error?.localizedDescription))")
            onCompletion(true)
        }
    }
}

func getEventsFromDb() -> [Event]
{
    var events = [Event]()
    if let app = app {
        let user = app.currentUser
        let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
        let query = realm.objects(Event.self)
        for e in query {
            events.append(e)
        }
    }
    return events
}


func postEvent(event: Event) -> Void {
    if let app = app {
        let user = app.currentUser
        let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
        let eventsInDb = realm.objects(Event.self)
        //        let eventInDB = eventsInDb.where {
        //            ($0._id == event._id)
        //        }
        try! realm.write {
            realm.add(event, update: .modified)
        }
    }
}

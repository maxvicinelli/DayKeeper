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

// Extend RealmSwift.List so that we can encode a user's connected users array to BSON document
extension RealmSwift.List where Element == String {
    func toArray() -> [AnyBSON] {
        var bsonArray = [AnyBSON]()
        for e in self {
            bsonArray.append(AnyBSON(e))
        }
        return bsonArray
    }
 }

func createCustomUserDataDocument(vm: AuthenticationModel, onCompletion: @escaping (Bool) -> Void) {
    if let app = app {
        let user = app.currentUser
        let client = user!.mongoClient("mongodb-atlas")
        let database = client.database(named: "DK")
        let collection = database.collection(withName: "User")
        collection.insertOne([
            "_id": AnyBSON(user!.id),
            "_partition": AnyBSON(user!.id),
            "connectedUsers": AnyBSON(RealmSwift.List<String>().toArray())
        ]) { (result) in
            switch result {
                case .failure(let error):
                    print("Failed to insert document: \(error.localizedDescription)")
                case .success(let newObjectId):
                print("Inserted custom user data document with object ID: \(newObjectId)")
            }
        }
    }
}

func updateConnectedUsers(vm: AuthenticationModel, onCompletion: @escaping (Bool) -> Void) {
    if let app = app {
        let user = app.currentUser
        let client = user!.mongoClient("mongodb-atlas")
        let database = client.database(named: "DK")
        let collection = database.collection(withName: "User")
        
        // Refresh the custom user data
        user!.refreshCustomData { (result) in
            switch result {
            case .failure(let error):
                print("Failed to refresh custom data: \(error.localizedDescription)")
            case .success(let customData):
                let usersArray = customData["connectedUsers"]! as! NSArray
                let usersList = RealmSwift.List<String>()
                for u in usersArray {
                    usersList.append(u as! String)
                }
                
//                let updateString = "test55555"
//                usersList.append(updateString)
                
                collection.updateOneDocument(
                    filter: ["_partition": AnyBSON(user!.id)],
                    update: ["_partition": AnyBSON(user!.id),
                             "_id": AnyBSON(user!.id),
                             "connectedUsers": AnyBSON(usersList.toArray())]
                ) { (result) in
                    switch result {
                    case .failure(let error):
                        print("Failed to update: \(error.localizedDescription)")
                        return
                    case .success(let updateResult):
                        //  User document updated.
                        print("Matched: \(updateResult.matchedCount), updated: \(updateResult.modifiedCount)")
                    }
                }
                return
            }
        }
        
//        var cU1 = user!.customData["connectedUser1"]
//        var cU2 = user!.customData["connectedUser2"]
//        var cU3 = user!.customData["connectedUser3"]
//        var cU4 = user!.customData["connectedUser4"]
//        var cU5 = user!.customData["connectedUser5"]
//
//        let updateString = "test55555"
//
//        if cU1!!.stringValue! != "no-user" {
//            if cU2!!.stringValue! != "no-user" {
//                if cU3!!.stringValue! != "no-user" {
//                    if cU4!!.stringValue! != "no-user" {
//                        if cU5!!.stringValue! != "no-user" {
//                            print("hmm")
//                        } else {
//                            cU5 = AnyBSON(updateString)
//                        }
//                    } else {
//                        cU4 = AnyBSON(updateString)
//                    }
//                } else {
//                    cU3 = AnyBSON(updateString)
//                }
//            } else {
//                cU2 = AnyBSON(updateString)
//            }
//        } else {
//            cU1 = AnyBSON(updateString)
//        }
//
//        collection.updateOneDocument(
//            filter: ["_partition": AnyBSON(user!.id)],
//            update: ["_partition": AnyBSON(user!.id),
//                     "connectedUser1": cU1!!,
//                     "connectedUser2": cU2!!,
//                     "connectedUser3": cU3!!,
//                     "connectedUser4": cU4!!,
//                     "connectedUser5": cU5!!]
//        ) { (result) in
//            switch result {
//            case .failure(let error):
//                print("Failed to update: \(error.localizedDescription)")
//                return
//            case .success(let updateResult):
//                //  User document updated.
//                print("Matched: \(updateResult.matchedCount), updated: \(updateResult.modifiedCount)")
//            }
//        }
    }
}

func getEventsFromDb() -> [Event]
{
    var events = [Event]()
    if let app = app {
        let user = app.currentUser
        if user == nil {
            return events
        }
        else if user!.isLoggedIn {
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            let query = realm.objects(Event.self)
            for e in query {
                events.append(e)
            }
        }
    }
    return events
}


func postEvent(event: Event, updating: Bool) -> Void {
    if let app = app {
        let user = app.currentUser
        let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
        let eventsInDb = realm.objects(Event.self)
        //        let eventInDB = eventsInDb.where {
        //            ($0._id == event._id)
        //        }
        try! realm.write {
            if updating {
                realm.add(event, update: .modified)
            } else {
                realm.add(event)
            }
        }
    }
}

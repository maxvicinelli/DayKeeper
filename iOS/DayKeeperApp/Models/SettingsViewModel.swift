//
//  SettingsViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/2/22.
//

import Foundation
import RealmSwift

final class SettingsViewModel: ObservableObject {
    
    @Published var childEVM: EventsViewModel = EventsViewModel()
    
//    @Published var childUUID: UUID = UUID()
    @Published var childEmail: String = ""
    @Published var childPassword: String = ""
    @Published var childUUID: UUID = UUID()
    
    @Published var authorized: Bool = false
    
    @Published var parentEmail: String = ""
    
    @Published var parentAccount = false
    
    // CHILD SETTINGS
    
    @Published var canCreateEvents = false
    @Published var canLocationTrack = true
    
    
    func setParentAccount() {
        
        print("called setParentAccount")
        if let app = app {
            let user = app.currentUser
            let client = user!.mongoClient("mongodb-atlas")
            let database = client.database(named: "DK")
            let collection = database.collection(withName: "User")
            
            
            DispatchQueue.main.async {
                
            
            
            user!.refreshCustomData { (result) in
                switch result {
                case .failure(let error):
                    print("Failed to refresh custom data: \(error.localizedDescription)")
                case .success(let customData):
                    
                    
                    print("PRINTING CUSTOM DATA")
                    print(user?.customData)
                    
                    print("now creating collection")
                    collection.updateOneDocument(
                        filter: ["_partition": AnyBSON(user!.id)],
                        update: ["_partition": AnyBSON(user!.id),
                                 "_id": AnyBSON(user!.id),
                                 "connectedUser": AnyBSON(customData["connectedUser"]! as! String),
                                 "childPassword": AnyBSON(customData["childPassword"]! as! String),
                                 "canCreateEvents": AnyBSON(customData["canCreateEvents"]! as! Bool),
                                 "canLocationTrack": AnyBSON(customData["canLocationTrack"]! as! Bool),
                                 "parentAccount": AnyBSON(self.parentAccount)]
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
                }
            }
            }
        }
    }
    
  
    
    func setChildEmail(childUUID: String) {
        
        print("called setParentAccount")
        if let app = app {
            let user = app.currentUser
            let client = user!.mongoClient("mongodb-atlas")
            let database = client.database(named: "DK")
            let collection = database.collection(withName: "User")
            
            
            user!.refreshCustomData { (result) in
                switch result {
                case .failure(let error):
                    print("Failed to refresh custom data: \(error.localizedDescription)")
                case .success(let customData):
                    
                    print("now creating collection")
                    collection.updateOneDocument(
                        filter: ["_partition": AnyBSON(user!.id)],
                        update: ["_partition": AnyBSON(user!.id),
                                 "_id": AnyBSON(user!.id),
                                 "connectedUser": AnyBSON(self.childEmail),
                                 "childPassword": AnyBSON(self.childPassword),
                                 "canCreateEvents": AnyBSON(customData["canCreateEvents"] as! Bool),
                                 "canLocationTrack": AnyBSON(customData["canLocationTrack"] as! Bool),
                                 "parentAccount": AnyBSON(customData["parentAccount"] as! Bool)]
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
                }
            }
        }
    }
    
    

    
    
    
    func getConnectionFromDB() {
        print("calling get connection from DB")
        if let app = app {
            let user = app.currentUser
            
            print("current user id: \(user?.id)")
            
            print("now attempting to refresh custom data")
            
            
            // Refresh the custom user data
            user!.refreshCustomData { (result) in
                switch result {
                case .failure(let error):
                    
                    print("Failed to refresh custom data: \(error.localizedDescription)")
                case .success(let customData):
                    
                    print("refreshing worked!")
                    
                    
                    print("NOW PRINTING CUSTOM DATA")
                    print(user?.customData)
 
                    DispatchQueue.main.async {
                        if customData["connectedUser"] != nil {
                            self.childEmail = customData["connectedUser"]! as! String
                            
                            if self.childEmail != "" {
                                self.authorized = true 
                            }
                        }
                       
                        print("got users array")
                        
                        if customData["canCreateEvents"] != nil {
                            self.canCreateEvents = customData["canCreateEvents"]! as! Bool
                        }
                        
                        print("got can create events ")
                        if customData["canLocationTrack"] != nil {
                            self.canLocationTrack = customData["canLocationTrack"]! as! Bool
                        }
                        
                        if customData["childPassword"] != nil {
                            self.childPassword = customData["childPassword"]! as! String
                        }
                        
                        print("got can location track ")
                        if customData["parentAccount"] != nil {
                            self.parentAccount = customData["parentAccount"]! as! Bool
                            print("parent account: \(self.parentAccount)")
                            print("got parent acct")
                        }
                        
                        self.attemptAuthorization()
   
                    }
                }
            }
        }
        
    }
    
    func attemptAuthorization() {
        let authModel = AuthenticationModel()
        authModel.email = childEmail
        authModel.password = childPassword
        let app = app
        let parent = app?.currentUser
        
        print("PARENT ID: \(parent?.id)")
        
        print("child username: \(authModel.email)")
        print("child password: \(authModel.password)")
        
        
        var child = app?.currentUser
        signIn(vm: authModel, onCompletion: { (success) in
            if (success) {
                print("child login successful ")
                
                DispatchQueue.main.async {
                    child = app?.currentUser
                    
                    let realm = try! Realm(configuration: (child?.configuration(partitionValue: child!.id))!)
                    
                    let query = realm.objects(Event.self)
                    print("here is what we got")
                    print(query)
                    for e in query {
                        if !e.isInvalidated {
                            !self.childEVM.events.contains(where: {$0._id == e._id}) ? self.childEVM.events.append(e) : print("not appending to events")
                        }
                    }
 
            
                    let childUUID = child?.id
                    print("child id: \(childUUID!)")
                    self.childEVM.loadFromDB()

                    app?.switch(to: parent!)
                    
                    self.setChildEmail(childUUID: childUUID!)
                    self.authorized = true
                }
                
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

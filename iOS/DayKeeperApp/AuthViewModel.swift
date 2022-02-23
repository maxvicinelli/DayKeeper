//
//  AuthViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/2/22.
//

// Created w/ help from https://cocoacasts.com/networking-essentials-how-to-implement-basic-authentication-in-swift

import Foundation
import RealmSwift
import EventKit


final class AuthenticationModel: ObservableObject {
    
    // @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    
    @Published var authenticated = false
    
    @Published var registering = false
    
    @Published var viewingSettings = false 
    
   
    
    // @Published var signingIn = false
    
    func setRegistration(value: Bool) {
        self.registering = value
    }
    
  

    func updateSettings() {
        self.viewingSettings = true
    }
    
    func cancelSettings() {
        self.viewingSettings = false
    }
    
    func attemptRegistration() -> Bool {
        
        print("called attempt Registration")
        
        
        if password == "" && email == "" {
            print("bad registration")
            return false
        }
        
        registerUser(vm: self, onCompletion: { (success) in
            if (success) {
                print("Creating the following account: ")
                print("email \(self.email)")
                print("password \(self.password)")
            } else {
                print("Did not create")
            }
        })
        
        
        let eventStore = EKEventStore()
        
        print("got event store")
        
        
        // change this in the future - maybe we want an insuccessful registration if user doesn't grant access to their calendar?
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                
                print("granted!")
                let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: nil)
                
                print("lets get events")
                
                let events = eventStore.events(matching: predicate)
                print(events)

            }
        }
        
        authenticated = true
        return true
    }
}

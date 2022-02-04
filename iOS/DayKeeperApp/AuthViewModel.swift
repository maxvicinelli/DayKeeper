//
//  AuthViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/2/22.
//

// Created w/ help from https://cocoacasts.com/networking-essentials-how-to-implement-basic-authentication-in-swift

import Foundation

import EventKit


final class AuthenticationModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    
    @Published var authenticated = false
    
    @Published var registering = false 
    
   
    
    // @Published var signingIn = false
    
    func beginRegistration() {
        self.registering = true
    }
    
    func attemptRegistration() {
        
        print("called attempt Registration")
        
        let eventStore = EKEventStore()
        
        print("got event store")
        
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
    }
    
    
    
    func attemptSignIn() -> Bool {
        
        print("signing in")
        
        if username == "Maxvicinelli" && password == "password" {
            authenticated = true
            return true
        } else {
            authenticated = false
            return false
        }
    }
    
}

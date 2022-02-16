//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//

import SwiftUI
import RealmSwift

struct EventView: View {
//    @ObservedRealmObject var events: [Event]
    var events: [Event]
    
    @ObservedObject var authModel: AuthenticationModel
    
    //@ObservedRealmObject var event: Event
    var body: some View {
        
        VStack {
            NavigationView {
                List {
                    ForEach(events) { event in
                        NavigationLink {
                            EventRow(event: event)
                        } label:
                        {
                            Text(event.Title)
                        }
                    }
                }
                .navigationTitle("Events")
                .toolbar {
                    
                    
                    HStack {
                        Button("Settings", action: {
                            authModel.updateSettings()
                            print("updated settings!")
                        })
                        Button("Send to Realm", action: { sendToRealm(events: events) })
                    }
                    
                    
                        
                        
                
                }
            }
            
            
        }
        
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(events: dummyEvents(), authModel: AuthenticationModel())
.previewInterfaceOrientation(.portraitUpsideDown)
        //EventView()
    }
}

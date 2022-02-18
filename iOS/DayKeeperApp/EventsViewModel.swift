//
//  EventsViewModel.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/16/22.
//

import Foundation

final class EventsViewModel : ObservableObject {
    @Published var events : [Event] = [Event]()
    func update() -> Void {
        
        print("----------------------------")
        
        self.events = getEventsFromDb().events
    }
//    override func viewWillAppear(_ animated : Bool) {
//        events = getEventsFromDb().events
//        super.viewWillAppear(animated)
//        print("test")
//    }
}

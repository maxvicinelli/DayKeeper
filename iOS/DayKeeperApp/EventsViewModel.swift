//
//  EventsViewModel.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/16/22.
//

import Foundation

final class EventsViewModel : ObservableObject {
    @Published var events : [Event] = [Event]()
}

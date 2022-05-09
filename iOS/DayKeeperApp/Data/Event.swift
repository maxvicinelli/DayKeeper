//
//  Event.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/5/22.
//

import Foundation
import RealmSwift

// The events for a user.
// Each has its own id (either a UUID string or an event identifier from iCal)
// links back to a user via that user's UUID,
// has a title and description,
// a category for the type of event
// (i.e., appointment, class, etc. – these will be treated differently by the model)
// start and end date to know when the event is occurring
// the amount of time to notify the user before (in minutes)
// the cadence / recurrence pattern of the events,
// ontime – an integer value representing how late the user was for the event (minutes)
// preevents – a list of pre-events associated with the event that must be done before the event
final class Event : Object, ObjectKeyIdentifiable, Identifiable /*Decodable, Encodable*/ {
    @Persisted(primaryKey: true) var _id : String//= UUID()
    @Persisted var UserId : UUID
    @Persisted var Title: String
    @Persisted var Description: String
    @Persisted var StartDate: Date
    @Persisted var EndDate: Date
    //@Persisted var Recurrence: String
    @Persisted var Category: Category? = nil
    @Persisted var OnTime: Int
    @Persisted var NotifBefore: Int
    @Persisted var CreationMethod: String
    @Persisted var Tasks = List<String>()
    @Persisted var Timeliness = List<Int>()
}


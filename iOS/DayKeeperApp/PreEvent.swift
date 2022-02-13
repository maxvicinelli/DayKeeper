//
//  PreEvent.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import Foundation
import RealmSwift


// The "pre-events" for an event.
// This is to say some task that must be accomplished before the actual event,
// e.g., shower, brush teeth, prepare lunch before leaving for school.
// it has a UUID,
// an EventId which links it back to the event it is associated with
// a Description,
// a 'Done' boolean which represents if the user actually accomplished the pre-event
// and 'NotifBefore', the amount of time before the event to notify the user to do this pre-event
//final class PreEvent : Object, ObjectKeyIdentifiable, Codable
//{
//    @Persisted(primaryKey: true) var Id = ObjectId()
//    @Persisted var EventId : ObjectId
//    @Persisted var Description : String
//    @Persisted var Done : Bool
//    @Persisted var NotifBefore : Int
//}

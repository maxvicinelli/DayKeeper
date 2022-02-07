//
//  EventRow.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import SwiftUI
import RealmSwift

struct EventRow: View {
    //@ObservedRealmObject var event: Event
    var body: some View {
        HStack {
            VStack {
                Text("Test1")
            }
            VStack {
                Text("Words1")
            }
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow()
    }
}

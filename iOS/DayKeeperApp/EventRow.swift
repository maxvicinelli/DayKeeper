//
//  EventRow.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import SwiftUI
import RealmSwift

struct EventRow: View {
    var event: Event
    //@ObservedRealmObject var event: Event
    var body: some View {
        Text(event.Title)
            .font(.title)
        Text(event.Description)
            .font(.subheadline)
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Properties")) {
                    Text("Category")
                        .bold()
                    Text(event.Category)
                    Text("Start Date")
                        .bold()
                    Text("\(event.StartDate)")
                    Text("End Date")
                        .bold()
                    Text("\(event.EndDate)")
                    Text("Recurrence")
                        .bold()
                    Text(event.Recurrence)
                    Text("Notify me before")
                        .bold()
                    Text("\(event.NotifBefore)")
                }.headerProminence(.increased)
                Section(header: Text("Pre-Events")) {
                    ForEach(event.PreEvents) { pre in
                            NavigationLink {
                                PreEventRow(pre: pre)
                            } label: {
                                Text(pre.Description)
                            }
                    }
                }.headerProminence(.increased)
            }
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event()
        EventRow(event: event)
    }
}

//
//  EventEditView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/15/22.
//

import SwiftUI

struct EventEditView: View {
    @State var event : Event
    var body: some View {
        TextField("Title", text: $event.Title)//, text: "Title")
            .font(.title)
        TextField("Description", text: $event.Description)
            .font(.subheadline)
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Properties")) {
                    Text("Category")
                        .bold()
                    Text(/*event.Category?.Title ?? */"No title")
                    Text("Start Date")
                        .bold()
                    Text("\(event.StartDate)")
                    Text("End Date")
                        .bold()
                    Text("\(event.EndDate)")
                    Text("Recurrence")
                        .bold()
                    Text(/*event.Category?.Cadence ?? */"NEVER")
                    Text("Notify me before")
                        .bold()
                    Text("\(event.NotifBefore)")
                }.headerProminence(.increased)
                Section(header: Text("Tasks")) {
                    if (event.Tasks != nil)
                    {
                        ForEach(event.Tasks!)
                        { task in
                            NavigationLink {
                                TaskRow(task: task)
                            } label: {
                                Text(task.Title)
                            }
                        }
                    }
                }.headerProminence(.increased)
            }
        }
    }
}

struct EventEditView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event()
        EventEditView(event: event)
    }
}

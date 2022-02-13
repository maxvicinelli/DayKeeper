//
//  PreEventRow.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/7/22.
//

import SwiftUI

struct TaskRow: View {
    var task : Event
    var body: some View {
        Text(task.Title)
            .font(.title)
        Text(task.Description)
            .font(.subheadline)
        List {
            Section(header: Text("Properties")) {
                Text("On time")
                    .bold()
                Text("\(task.OnTime)")
                Text("Notify me before")
                    .bold()
                Text("\(task.NotifBefore)")
            }.headerProminence(.increased)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let task = Event()
        TaskRow(task: task)
    }
}

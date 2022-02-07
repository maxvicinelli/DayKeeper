//
//  PreEventRow.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/7/22.
//

import SwiftUI

struct PreEventRow: View {
    var pre : PreEvent
    var body: some View {
        Text(pre.Description)
            .font(.title)
        List {
            Section(header: Text("Properties")) {
                Text("Done?")
                    .bold()
                Text(pre.Done ? "Yes" : "No")
                Text("Notify me before")
                    .bold()
                Text("\(pre.NotifBefore)")
            }.headerProminence(.increased)
        }
    }
}

struct PreEventRow_Previews: PreviewProvider {
    static var previews: some View {
        let pre = PreEvent()
        PreEventRow(pre: pre)
    }
}

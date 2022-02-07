//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//

import SwiftUI
import RealmSwift

struct EventView: View {
    //@ObservedRealmObject var event: Event
    var body: some View {
        NavigationView {
            NavigationLink {
                EventRow()
            } label:
            {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
//            List {
//                ForEach() { event in
//                    NavigationLink {
//                        EventRow()
//                    } label:
//                    {
//                        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                    }
//                }
//            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
        //EventView()
    }
}

//
//  HelpView.swift
//  DayKeeperApp
//
//  Created by Jonah Kalsner Kershen on 2/6/22.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            Text("do you need help?")
                .font(.title)
            Text("Frequently asked questions:")
                .font(.subheadline)
            VStack{
                Text("How can I decrease the frequency of notifications?")
                Text("Answer")
                    .foregroundColor(.red)
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

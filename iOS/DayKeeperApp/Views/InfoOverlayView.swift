//
//  InfoOverlayView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/13/22.
//

import SwiftUI

struct InfoOverlayView: View {
    let infoMessage: String
    let buttonTitle: String
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(infoMessage)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Button {
                action()
            } label: {
                Label(buttonTitle, systemImage: systemImageName)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(5)
        }
        .padding()
    }
}

struct InfoOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        InfoOverlayView(infoMessage: "temp", buttonTitle: "temp", systemImageName: "temp", action: {})
    }
}

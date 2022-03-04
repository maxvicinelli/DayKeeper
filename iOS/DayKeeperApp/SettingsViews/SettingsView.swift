//
//  SettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    @State private var loggingOutConfirmation = false
    @State private var loggingOutFailure = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Back"){
                        authModel.cancelSettings()
                    }
                    .padding()
                    Spacer()
                    Text("Settings")
                        .font(.title)
                    Spacer()
                }

                NavigationView {
                    List {
                        NavigationLink(
                            destination: AccountSettingsView(authModel: authModel),
                            label: {
                                AccountSettingsRow()
                            }
                        )
                        .background(.blue)

                        NavigationLink(
                            destination: NotificationsSettingsView(),
                            label: {
                                NotificationsSettingsRow()
                            }
                        )

                                                           
                        Button("Log out", role: .destructive, action: { loggingOutConfirmation = true })
                            .confirmationDialog("Are you sure you want to log out?",
                                                isPresented: $loggingOutConfirmation,
                                                titleVisibility: .visible) {
                                HStack {
                                    Button("Yes", role: .destructive, action: {
                                        logoutUser(vm: authModel, onCompletion: { (failure) in
                                            loggingOutFailure = failure;
                                            if loggingOutFailure {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        loggingOutFailure = false
                                                }
                                            }
                                        })
                                    })
                                    Button("Cancel", role: .cancel, action: {})
                                }
                            }
                        }
                    }
                }
            if loggingOutFailure {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.gray)
                    .frame(width: 250, height: 250)
                    .overlay(
                        VStack {
                            Text("Failed to log out").font(.largeTitle)
                            Text("Try again later").font(.body)
                        })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(authModel: AuthenticationModel())
            SettingsView(authModel: AuthenticationModel())
            SettingsView(authModel: AuthenticationModel())
            SettingsView(authModel: AuthenticationModel())
                .previewInterfaceOrientation(.portraitUpsideDown)
            SettingsView(authModel: AuthenticationModel())
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}




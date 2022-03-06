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
//        ZStack {
        VStack(alignment: .center, spacing: 0) {
                HStack {
                    Button("Back"){
                        authModel.cancelSettings()
                    }
                    .padding()
                    Text("Settings")
                        .font(.title)
                }
                .background(.blue.opacity(0.1))
                NavigationView {
                    List {
                        NavigationLink(
                            destination: AccountSettingsView(authModel: authModel),
                            label: {
                                AccountSettingsRow()
                            }
                        )
                        .listRowBackground(Color.blue.opacity(0.1))
                        NavigationLink(
                            destination: NotificationsSettingsView(),
                            label: {
                                NotificationsSettingsRow()
                            }
                        )
                        .listRowBackground(Color.blue.opacity(0.1))
                        
                        Button("Log out", role: .destructive, action: { loggingOutConfirmation = true })
                            .listRowBackground(Color.blue.opacity(0.1))
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
                       .background(Color.blue.opacity(0.1))
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
//        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(authModel: AuthenticationModel())
    }
}




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
    
    @ObservedObject var settingsModel: SettingsViewModel
    

    init(authModelParam: AuthenticationModel, settingsViewModelParam: SettingsViewModel) {
        UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
        self.authModel = authModelParam
        self.settingsModel = settingsViewModelParam
    }
       
    var body: some View {

        if settingsModel.parentAccount {

            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    Text("Settings")
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 40)!))
                        .foregroundColor(.textColor)
                        .frame(alignment: .center)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 65, alignment: .center)
                .background(Color(red:0.436, green: 0.558, blue: 0.925))

                NavigationView {
                    ZStack {
                        Color.red.ignoresSafeArea(.all)
                        List {
                            NavigationLink(
                                destination: AccountSettingsView(authModel: authModel),
                                label: {
                                    AccountSettingsRow()
                                }
                            )
                            .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))

                            
                            NavigationLink(
                                destination: NotificationsSettingsView(),
                                label: {
                                    NotificationsSettingsRow()
                                }
                            )
                            .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
                            
                            NavigationLink(
                                destination: AddChildrenView(settingsViewModel: settingsModel),
                                label: {
                                    AddChildrenRow()
                                })
                            .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
                            
                            NavigationLink(
                                destination: ChildSettingsView(settingsViewModel: settingsModel),
                                label: {
                                    ChildSettingsRow()
                            })
                            .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
                            
                            Button("Log out", role: .destructive, action: { loggingOutConfirmation = true })
                                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                                .frame(width: 260, height: 60, alignment: .center)
                                .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
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
                                                            authModel.authenticated = false
                                                            authModel.registering = false

                                                    }
                                                }
                                            })
                                        })
                                        Button("Cancel", role: .cancel, action: {})
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
                                .background(Color(red:0.436, green: 0.558, blue: 0.925))
                        }
                }
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
            }
        } else {
            ChildAcctSettingsView(settingsViewModel: settingsModel)
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(authModelParam: AuthenticationModel(), settingsViewModelParam: SettingsViewModel())
    }
}

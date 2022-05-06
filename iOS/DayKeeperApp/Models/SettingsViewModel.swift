//
//  SettingsViewModel.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/2/22.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
//    @Published var childUUID: UUID = UUID()
    @Published var childEmail: String = ""
    @Published var childPassword: String = ""
    
    func addChild() {
        print("called addChild")
    }
    
    
    
}

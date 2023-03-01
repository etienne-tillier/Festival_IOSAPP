//
//  FestivalAppApp.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI
import FirebaseCore

@main
struct FestivalAppApp: App {
    
    @StateObject var user : UserSettings = UserSettings()
    @State var zones : ZoneList = ZoneList()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(zones: zones)
                .environmentObject(user)

        }
    }
}

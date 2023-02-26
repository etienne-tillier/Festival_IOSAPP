//
//  FestivalAppApp.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

@main
struct FestivalAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(benevoles : BenevoleList())
        }
    }
}

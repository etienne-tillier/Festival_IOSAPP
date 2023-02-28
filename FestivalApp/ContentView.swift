//
//  ContentView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 28/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user : UserSettings
    
    var body: some View {
            if user.user != nil {
                BenevolePanelView(benevoles : BenevoleList())
            }
            else {
                AuthView()
            }
    }
}

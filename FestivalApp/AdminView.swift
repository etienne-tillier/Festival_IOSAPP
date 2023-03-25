//
//  AdminView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 22/03/2023.
//

import SwiftUI

struct AdminView: View {

    @ObservedObject var zones: ZoneList
    @State var zonesIntent : ZoneListIntent
    @State private var action: Int? = 0
    @State var benevoles = BenevoleList()

    init(zones: ZoneList) {
        self.zones = zones
        self.zonesIntent = ZoneListIntent(zones: zones)
    }
    
    
    
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: BenevolePanelView(benevoles: benevoles), tag: 1, selection: $action) {
                EmptyView()
            }
            NavigationLink(destination: AdminZoneView(zones: zones), tag: 2, selection: $action) {
                EmptyView()
            }
            VStack{
                Label("Bénévoles", systemImage: "person.3.fill")
                    .onTapGesture {
                        self.action = 1
                    }
                Label("Affectations", systemImage: "calendar")
                    .onTapGesture {
                        self.action = 2
                    }
            }.onAppear{
                Task{
                    self.action = 0
                }
            }
        }

    }
}


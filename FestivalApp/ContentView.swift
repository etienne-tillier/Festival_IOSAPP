//
//  ContentView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 28/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user : UserSettings
    @State var benevoles : BenevoleList = BenevoleList()
    @State var zoneIntent : ZoneListIntent
    @ObservedObject var zones : ZoneList
    
    init(zones : ZoneList){
        self.zones = zones
        self._zoneIntent = State(initialValue: ZoneListIntent(zones: zones))
    }
    
    var body: some View {
            if user.user != nil {
                VStack {
                    switch self.zones.state{
                    case .isLoading:
                        ProgressView()
                    case .ready:
                        Picker("Zones", selection: $zones.zones) {
                            ForEach(zones.zones, id: \.self) { zone in
                                Text(zone.nom)
                            }
                        }
                        BenevolePanelView(benevoles : benevoles)
                    default:
                        Text("default")
                    }
                }.onAppear{
                    Task{
                        await zoneIntent.getAllZone()
                    }
                }
                
            }
            else {
                AuthView()
            }
    }
}

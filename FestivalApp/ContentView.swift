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
    @State var zonesIntent : ZoneListIntent
    @ObservedObject var zones : ZoneList
    @State var selectedZone : Zone = Zone(id: "1", nom: "Tous les bénévoles", creneaux: [], jeux: [])
    
    init(zones : ZoneList){
        self.zones = zones
        self.zonesIntent = ZoneListIntent(zones: zones)
    }
    
    
    var body: some View {
            if user.user != nil {
                VStack {
                    switch self.zones.state{
                    case .isLoading:
                        ProgressView()
                    case .ready:
                        Picker("Zones", selection: $selectedZone) {
                            ForEach(zones.zones, id: \.self) { zone in
                                Text(zone.nom)
                            }
                        }.onChange(of: selectedZone) { selectedZone in
                            withAnimation{
                                self.selectedZone = selectedZone
                            }
                        }
                        if selectedZone.id == "1" {
                            BenevolePanelView(benevoles: benevoles)
                        }
                        else {
                            
                        }
                    default:
                        Text("default")
                    }
                }.onAppear{
                    Task{
                        await zonesIntent.getAllZone()
                        self.zones.zones.insert(selectedZone, at: 0)
                    }
                }
                
            }
            else {
                AuthView()
            }
    }
}

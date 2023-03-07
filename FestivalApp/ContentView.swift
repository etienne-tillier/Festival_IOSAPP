//
//  ContentView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 28/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user: UserSettings
    @State var benevoles = BenevoleList()
    @State var zonesIntent: ZoneListIntent
    @ObservedObject var zones: ZoneList
    private var dao = ZoneDAO()
    @State var selectedZone = Zone(id: "1", nom: "Tous les bénévoles", creneaux: [], jeux: [])
    @ObservedObject var displayedZone = Zone(id: "1", nom: "Tous les bénévoles", creneaux: [], jeux: [])
    var selectedZoneIntent: ZoneIntent

     init(zones: ZoneList) {
         self.selectedZoneIntent = ZoneIntent(zone: _displayedZone.wrappedValue)
         self.zones = zones
         self.zonesIntent = ZoneListIntent(zones: zones)
     }
    
    func fetchCurrentZone(id : String) async {
        if (selectedZone.id != "1"){
            await dao.getZoneById(id: selectedZone.id) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let zone):
                    DispatchQueue.main.async {
                        withAnimation{
                            self.selectedZoneIntent.load(zone: zone)
                        }
                    }

                }
            }
        }
        else {
            withAnimation{
                DispatchQueue.main.async {
                    self.selectedZoneIntent.load(zone: selectedZone)
                }
            }
        }
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
                        Task{
                            await fetchCurrentZone(id: selectedZone.id)
                        }
                    }.onAppear{
                        Task{
                            self.zones.zones.insert(selectedZone, at: 0)
                        }
                    }
                    if self.displayedZone.id == "1" {
                        BenevolePanelView(benevoles: benevoles)
                            .environmentObject(zones)
                    }
                    else {
                        CreneauListView(creneaux: CreneauList(creaneaux: displayedZone.creneaux), selectedZone: displayedZone)
                            .environmentObject(zones)
                    }
                default:
                    Text("Error")
                }
            }.onAppear{
                zonesIntent.getAllZone()
            }
        }
            else {
                AuthView()
            }
    }
}

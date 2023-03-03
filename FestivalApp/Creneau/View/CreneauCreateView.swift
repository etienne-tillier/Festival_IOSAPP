//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct CreneauCreateView: View {
    
    @EnvironmentObject var zones : ZoneList
    @ObservedObject var benevole : Benevole
    @State var selectedZone : Zone = Zone()
    @State var selectedZoneIntent : ZoneIntent = ZoneIntent()
    @State var pickerZoneList : [Zone] = []
    @State private var selectedDate = Date()
    @State private var startHour = 0
    @State private var endHour = 0

    
    
    init(benevole: Benevole) {
        self.benevole = benevole
    }
    
    var body: some View {
        VStack{
            Picker("Zones", selection: $selectedZone) {
                ForEach(pickerZoneList, id: \.self) { zone in
                    Text(zone.nom)
                }
            }.onAppear{
                self.pickerZoneList = self.zones.zones
                self.selectedZoneIntent = ZoneIntent(zone: selectedZone)
                self.pickerZoneList.remove(at: 0)
            }
            .onChange(of: selectedZone) { selectedZone in
                self.selectedZoneIntent.load(zone: selectedZone)
            }
            Form {
                        Section(header: Text("Date")) {
                            DatePicker(
                                "Select a date",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                        }
                        
                        Section(header: Text("Start hour")) {
                            Stepper(value: $startHour, in: 0...23) {
                                Text("\(startHour):00")
                            }
                        }
                        
                        Section(header: Text("End hour")) {
                            Stepper(value: $endHour, in: 0...23) {
                                Text("\(endHour):00")
                            }
                        }
                    }
            Button(action: {
                
            }, label: {
                Text("Enregistrer")
            })
        }
    }
}


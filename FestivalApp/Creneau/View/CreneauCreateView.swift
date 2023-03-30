//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct CreneauCreateView: View {
    
    @EnvironmentObject var error : ErrorObject
    @EnvironmentObject var zones : ZoneList
    @ObservedObject var benevole : Benevole
    @State var selectedZone : Zone = Zone()
    @State var selectedZoneIntent : ZoneIntent = ZoneIntent()
    @State var pickerZoneList : [Zone] = []
    @State private var selectedDate = Date()
    @State private var startHour = 12
    @State private var endHour = 15
    @ObservedObject private var festival : Festival
    @State private var dateRange : ClosedRange<Date>? = nil
    @Environment(\.presentationMode) var presentationMode
    
    
    init(benevole: Benevole, festival : Festival) {
        self.benevole = benevole
        self.festival = festival
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
                self.selectedZoneIntent.load(zone: self.zones.zones[1])
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
                        in: dateRange!,
                        displayedComponents: [.date]
                    )
                }
                
                Section(header: Text("Start hour")) {
                    HStack{
                        Text("\(startHour) h")
                            .foregroundColor(.black)
                        Stepper(value: $startHour, in: 0...(endHour - 1)) {
                            Text("\(startHour):00")
                        }
                    }
                    
                }
                
                Section(header: Text("End hour")) {
                    HStack{
                        Text("\(endHour) h")
                            .foregroundColor(.black)
                        Stepper(value: $endHour, in: (startHour + 1)...23) {
                            Text("\(endHour):00")
                        }
                    }
                    
                }
            }
            Button(action: {
                Task {
                    await self.selectedZoneIntent.addCreneau(benevole: benevole, date: selectedDate, heureDebut: startHour, heureFin: endHour) { result in
                        switch result {
                        case .failure(let error):
                            self.error.message = error.localizedDescription
                            self.error.isPresented = true
                        case .success((_)):
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }
            }, label: {
                Text("Enregistrer")
            })
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}


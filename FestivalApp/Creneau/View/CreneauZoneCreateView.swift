//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct CreneauZoneCreateView: View {
    
    @EnvironmentObject var zones : ZoneList
    @ObservedObject var zone : Zone
    @ObservedObject var benevoleAvailable : BenevoleList = BenevoleList()
    @State private var benevoleAvailableIntent : BenevoleListIntent
    @State var isValidated : Bool = false
    @State var selectedZone : Zone = Zone()
    @State private var selectedDate = Date()
    @State private var startHour = 12
    @State private var endHour = 15
    @State private var isChoosingBenevole : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    
    init(zone: Zone) {
        self.zone = zone
        self._benevoleAvailableIntent = State(initialValue: BenevoleListIntent(benevoles: _benevoleAvailable.wrappedValue))
    }
    
    func getBenevoleAvailable() async {
        await self.benevoleAvailableIntent.getBenevolesAvailableForCreneau(date: selectedDate, startHour: startHour, endHour: endHour)
        switch self.benevoleAvailable.state {
        case .error:
            print("error")
        case .ready:
            self.isChoosingBenevole = true
        default:
            break
        }
    }
    
    var body: some View {
        VStack{
            Form {
                        Section(header: Text("Date")) {
                            DatePicker(
                                "Select a date",
                                selection: $selectedDate,
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
                    await self.getBenevoleAvailable()
                }
            }, label: {
                Text("Choisir un bénévole")
            })
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isChoosingBenevole){
            BenevoleAvailableView(benevoles: benevoleAvailable)
        }
        /*
        .onChange(of: $isValidated){
            if isValidated {
                Task {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
        }
         */
    }
}


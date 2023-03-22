//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct CreneauZoneCreateView: View {
    
    @ObservedObject var benevoleAvailable : BenevoleList = BenevoleList()
    @ObservedObject var choosenBenevole : Benevole = Benevole()
    @State private var benevoleAvailableIntent : BenevoleListIntent
    private var selectedZoneIntent : ZoneIntent
    @State var isValidated : Bool = false
    @ObservedObject var selectedZone : Zone
    @State private var selectedDate = Date()
    @State private var startHour = 12
    @State private var endHour = 15
    @State private var isChoosingBenevole : Bool = false
    private var delegate : CreneauListView
    @Environment(\.presentationMode) var presentationMode
    
    
    init(zone: Zone, delegate : CreneauListView) {
        self.selectedZone = zone
        self._benevoleAvailableIntent = State(initialValue: BenevoleListIntent(benevoles: _benevoleAvailable.wrappedValue))
        self.selectedZoneIntent = ZoneIntent(zone: zone)
        self.delegate = delegate
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
    
    func addCreneau() async {
        await selectedZoneIntent.addCreneau(benevole: self.choosenBenevole, date: self.selectedDate, heureDebut: self.startHour, heureFin: self.endHour) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success((let creneau)):
                self.delegate.didAdd(creneau: creneau)
                self.presentationMode.wrappedValue.dismiss()
                
            }
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
            if self.choosenBenevole.id != "" {
                VStack{
                    Text("Benevole choisi")
                    BenevoleSimpleView(benevole: choosenBenevole)
                }
                HStack{
                    Button(action: {
                        Task {
                            await self.getBenevoleAvailable()
                        }
                    }, label: {
                        Text("Choisir un autre bénévole")
                    })
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    Button(action: {
                        Task {
                            await self.addCreneau()
                        }
                    }, label: {
                        Text("Valider")
                    })
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                }
            else {
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
            }

            
        .sheet(isPresented: $isChoosingBenevole){
            BenevoleAvailableView(benevoles: benevoleAvailable, chosenBenevole : choosenBenevole)
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
    


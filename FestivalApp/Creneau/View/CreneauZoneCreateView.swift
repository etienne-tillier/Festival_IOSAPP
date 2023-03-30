//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct CreneauZoneCreateView: View {
    
    
    @EnvironmentObject var error : ErrorObject
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
    @ObservedObject var festival : Festival
    @Environment(\.presentationMode) var presentationMode
    
    
    init(zone: Zone, delegate : CreneauListView, festi : Festival) {
        self.selectedZone = zone
        self._benevoleAvailableIntent = State(initialValue: BenevoleListIntent(benevoles: _benevoleAvailable.wrappedValue))
        self.selectedZoneIntent = ZoneIntent(zone: zone)
        self.delegate = delegate
        self.festival = festi
    }
    
    func getBenevoleAvailable() async {
        await self.benevoleAvailableIntent.getBenevolesAvailableForCreneau(date: selectedDate, startHour: startHour, endHour: endHour)
        switch self.benevoleAvailable.state {
        case .error:
            self.error.message = "Erreur pour récupérer les bénévoles"
            self.error.isPresented = true
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
                self.error.message = error.localizedDescription
                self.error.isPresented = true
            case .success((let creneau)):
                self.delegate.didAdd(creneau: creneau)
                self.presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
    
    func getDateRange() -> ClosedRange<Date> {
        let dateRange = {
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let startComponents = DateComponents(year: self.festival.dateDebut.getYear()!, month: self.festival.dateDebut.getMonth()!,
                                                 day: self.festival.dateDebut.getDay()!)
            let festivalDate : Date = dateFormatter.date(from: self.festival.dateDebut)!
            let end : Date = calendar.date(byAdding: .day, value: self.festival.jours.count - 1, to: festivalDate)!
            
            let components = end.get(.day, .month, .year)
            let endComponents = DateComponents(year: components.year,
                                               month: components.month,
                                               day: components.day)
            return calendar.date(from:startComponents)!
                ...
                calendar.date(from:endComponents)!
        }()
        return dateRange
    }
    
    func setSelectedDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.selectedDate = dateFormatter.date(from: self.festival.dateDebut)!
    }
    
    var body: some View {
        VStack{
            Form {
                        Section(header: Text("Date")) {
                            DatePicker(
                                "Select a date",
                                selection: $selectedDate,
                                in: getDateRange(),
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
                    Text("Bénévole choisi")
                        .foregroundColor(.gray)
                    BenevoleSimpleView(benevole: choosenBenevole)
                }
                HStack{
                    Button(action: {
                        Task {
                            await self.getBenevoleAvailable()
                        }
                    }, label: {
                        Text("Modifier")
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
        }.sheet(isPresented: $isChoosingBenevole){
            BenevoleAvailableView(benevoles: benevoleAvailable, chosenBenevole : choosenBenevole)
        }.onAppear{
            setSelectedDate()
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
    


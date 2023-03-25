//
//  BenevoleDispoAddView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 24/03/2023.
//

import SwiftUI

struct BenevoleDispoAddView: View {
    
    @ObservedObject var user : Benevole

    @State private var selectedDate = Date()
    @State private var startHour = 12
    @State private var endHour = 15
    @State private var userIntent : BenevoleIntent? = nil
    
    init(benevole : Benevole){
        self.user = benevole
    }
    
    @Environment(\.presentationMode) var presentationMode
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
                    await self.userIntent!.addDispo(date: selectedDate, heureDebut: startHour, heureFin: endHour){ result in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
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
        }.onAppear{
            self.userIntent = BenevoleIntent(benevole: user)
        }
    }
}


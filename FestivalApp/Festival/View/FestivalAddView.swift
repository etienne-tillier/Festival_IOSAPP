//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct FestivalAddView : View {
    
    @ObservedObject var festivals : FestivalList
    @State var intent : FestivalListIntent
    @State var nomText : String = ""
    @State private var selectedDate = Date()
    @State private var nbJours = 1
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(festivals: FestivalList) {
        self.festivals = festivals
        self._intent = State(initialValue : FestivalListIntent(festivals: festivals))
    }
    
    var body: some View {
        VStack{
            Form {
                
                        Section() {
                            TextField("Nom", text: $nomText)
                                .textFieldStyle(.roundedBorder).textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                                .textContentType(.givenName)
                                .foregroundColor(Color.black)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        Section(header: Text("Date de départ")) {
                            DatePicker(
                                "Select a date",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                        }

                        Section(header: Text("Nombre de jour")) {
                            HStack{
                                Text("\(nbJours) jours")
                                    .foregroundColor(.black)
                                Stepper(value: $nbJours, in: 1...100) {
                                    EmptyView()
                                }
                            }
  
                        }
                    }
            Button(action: {
                Task {
                    await self.intent.add(nom: nomText, dateDebut: selectedDate, nbJours: nbJours)
                    switch self.festivals.state {
                    case .error:
                        print("error")
                    case .ready:
                        self.presentationMode.wrappedValue.dismiss()
                    default:
                        break
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


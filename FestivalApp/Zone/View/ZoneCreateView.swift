//
//  CreneauCreateView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 03/03/2023.
//

import SwiftUI

struct ZoneCreateView : View {
    
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var festival : Festival
    @State var intent : FestivalIntent
    @State var nomText : String = ""
    @State private var nbBenev : Int = 1
    private var delegate : AdminZoneView
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(festival: Festival, delegate : AdminZoneView) {
        self.festival = festival
        self._intent = State(initialValue : FestivalIntent(festival: festival))
        self.delegate = delegate
    }
    
    var body: some View {
        VStack{
            Form {
                
                        Section() {
                            TextField("Nom de la zone", text: $nomText)
                                .textFieldStyle(.roundedBorder).textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                                .textContentType(.givenName)
                                .foregroundColor(Color.black)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                        }

                        Section(header: Text("Nombre de bénévoles")) {
                            HStack{
                                Text("\(nbBenev) bénévoles")
                                    .foregroundColor(.black)
                                Stepper(value: $nbBenev, in: 1...100) {
                                    EmptyView()
                                }
                            }
                        }.foregroundColor(.gray)
                    }
            Button(action: {
                Task {
                    await self.intent.addZone(festivalId: festival.id, nom: nomText, nbBenev: nbBenev){ result in
                        switch result {
                        case .failure(let error):
                            self.error.message = error.localizedDescription
                            self.error.isPresented = true
                        case .success(let zone):
                            delegate.didAdd(zone: zone)
                            self.presentationMode.wrappedValue.dismiss()
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


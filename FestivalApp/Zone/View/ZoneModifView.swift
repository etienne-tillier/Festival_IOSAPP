//
//  BenevoleModifView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import SwiftUI

struct ZoneModifView : View {
    
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var zone : Zone
    private var intent : ZoneIntent
    @State private var nom : String
    @State private var nbBenev : Int
    //variable pour gérer l'affichage de la modale
    @Environment(\.presentationMode) var presentationMode
    
    init(zone: Zone) {
        self.zone = zone
        self.intent = ZoneIntent(zone: zone)
        self._nom = State(initialValue: zone.nom)
        self._nbBenev = State(initialValue: zone.nbBenev)
    }
    
    func update() async {
        Task {
            await self.intent.updateZone(nom: nom, nbBenev: nbBenev){ result in
                switch result {
                case .success(()):
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    self.error.message = error.localizedDescription
                    self.error.isPresented = true
                }
            }
        }
    }
    
    var body: some View {
        //mettre un form
        VStack {
            Text("Modifier la zone")
                .font(.title)
                .padding()
                .foregroundColor(Color.black)
            Form {
                        Section() {
                            TextField("Nom", text: $nom)
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
            Section {
                HStack {
                    Button("Retour") {
                        //Enleve la modale
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    Button("Enregistrer") {
                        Task {
                            await self.update()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
    }
}

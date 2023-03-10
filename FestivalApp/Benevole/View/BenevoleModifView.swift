//
//  BenevoleModifView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import SwiftUI

struct BenevoleModifView: View {
    
    @ObservedObject var benevole : Benevole
    private var intent : BenevoleIntent
    @State private var nom : String
    @State private var prenom : String
    @State private var email : String
    //variable pour gérer l'affichage de la modale
    @Environment(\.presentationMode) var presentationMode
    
    init(benevole: Benevole, intent: BenevoleIntent) {
        self.benevole = benevole
        self.intent = intent
        self._prenom = State(initialValue: benevole.prenom)
        self._nom = State(initialValue: benevole.nom)
        self._email = State(initialValue: benevole.email)
    }
    
    func update() async {
        await self.intent.updateBenevole(nom: nom, prenom: prenom, email: email)
        switch self.benevole.state {
        case .ready:
            presentationMode.wrappedValue.dismiss()
        case .error:
            print("error updating")
        default:
            break
        }
    }
    
    var body: some View {
        //mettre un form
        VStack {
            Text("Modifier le bénévole")
                .font(.title)
                .padding()
                .foregroundColor(Color.black)
            Section {
                TextField("Nom", text: $nom)
                    .textFieldStyle(.roundedBorder).textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                    .textContentType(.givenName)
                    .foregroundColor(Color.black)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)

                TextField("Prénom", text: $prenom)
                    .textFieldStyle(.roundedBorder).textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                    .textContentType(.familyName)
                    .foregroundColor(Color.black)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder).textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

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

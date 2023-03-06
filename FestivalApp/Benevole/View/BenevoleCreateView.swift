//
//  BenevoleModifView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import SwiftUI

struct BenevoleCreateView: View {
    
    @ObservedObject var benevoles : BenevoleList
    private var intent : BenevoleListIntent
    @State private var nom : String = ""
    @State private var prenom : String = ""
    @State private var email : String = ""
    //variable pour gérer l'affichage de la modale
    @Environment(\.presentationMode) var presentationMode
    
    init(benevoles: BenevoleList, intent: BenevoleListIntent) {
        self.benevoles = benevoles
        self.intent = intent
    }
    
    var body: some View {
        //mettre un form
        VStack {
            Text("Créer un nouveau bénévole")
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
                        self.intent.add(nom: nom, prenom: prenom, email: email)
                        presentationMode.wrappedValue.dismiss()
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

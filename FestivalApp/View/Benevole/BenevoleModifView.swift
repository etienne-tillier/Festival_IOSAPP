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
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var email : String = ""
    
    init(benevole: Benevole, intent: BenevoleIntent) {
        self.benevole = benevole
        self.intent = intent
    }
    
    var body: some View {
        //mettre un form
        VStack {
            Section {
                TextField("Nom", text: $firstName)
                    .textContentType(.givenName)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onAppear {
                        firstName = benevole.nom
                    }
                TextField("Prénom", text: $lastName)
                    .textContentType(.familyName)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onAppear {
                        lastName = benevole.prenom
                    }
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onAppear {
                        email = benevole.email
                    }
            }
            Section {
                Button(action: {
                    //self.intent.modify
                }) {
                    Text("Enregistrer")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .navigationBarTitle("Modifier")
    }
}

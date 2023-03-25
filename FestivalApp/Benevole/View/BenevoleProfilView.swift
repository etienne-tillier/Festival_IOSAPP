//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct BenevoleProfilView : View {
    
    @EnvironmentObject var user : Benevole
    @ObservedObject private var benevole : Benevole
    private var intent : BenevoleIntent
    @State private var showModificationView : Bool = false
    @State private var isConfimationPresented : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(benevole: Benevole) {
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
    }
    
    
    
    func disconnect() {
        self.user.id = ""
    }
    
    
    var body: some View {
        NavigationView{
            VStack {
                Text(benevole.nom)
                Text(benevole.prenom)
                Text(benevole.email)
                HStack {
                    Button("Modifier") {
                        showModificationView = true
                    }
                    .sheet(isPresented: $showModificationView){
                        BenevoleModifView(benevole: benevole, intent: intent)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    Button("Déconnexion") {
                        isConfimationPresented = true
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
                .alert(isPresented: $isConfimationPresented) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                        primaryButton: .destructive(Text("Oui"), action: self.disconnect),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}


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
                Text("Bonjour " + self.benevole.prenom + " !")
                    .font(.system(size: 42))
                Spacer().frame(height: 35)
                Image("logo")
                    .resizable()
                    .frame(width: 160, height: 160)
                Spacer().frame(height: 20)
                Text("Mon compte")
                    .font(.system(size: 30))
                VStack{
                    Text(benevole.nom)
                        .padding(.vertical, 10)
                    Text(benevole.prenom)
                        .padding(.vertical, 10)
                    Text(benevole.email)
                        .padding(.vertical, 10)
                        //.padding(.horizontal, 150)
                }
                .background(Color.white)
                .padding(.horizontal, 90)
                .border(.black)
                .cornerRadius(10)
                Spacer().frame(height: 40)
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
                }
                .alert(isPresented: $isConfimationPresented) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                        primaryButton: .destructive(Text("Oui"), action: self.disconnect),
                        secondaryButton: .cancel()
                    )
                }
                Spacer().frame(height: 110)
                Button{
                    isConfimationPresented = true
                }
                label: {
                    HStack{
                        Image(systemName: "power")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(5)

            }
        }
    }
}


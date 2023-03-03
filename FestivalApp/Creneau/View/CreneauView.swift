//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct CreneauView: View {
    
    @ObservedObject private var creneau : Creneau
    private var intent : CreneauIntent
    @State private var showModificationView : Bool = false
    
    init(creneau: Creneau) {
        self.creneau = creneau
        self.intent = CreneauIntent(creneau: creneau)
    }
    
    var body: some View {
        VStack {
            Text(creneau.benevole.nom)
            Text(creneau.benevole.prenom)
            Text(creneau.benevole.email)
            HStack{
                Text(creneau.dateDebut.convertToDate()! + " " + String(creneau.dateDebut.getHour()!) + "h")
                Text(" - ")
                Text(creneau.dateFin.convertToDate()! + " " + String(creneau.dateFin.getHour()!) + "h")
            }
            HStack {
                Button("Modifier") {
                    showModificationView = true
                }
                .sheet(isPresented: $showModificationView){
                    //BenevoleModifView(benevole: benevole, intent: intent)
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
            
        }
    }
}


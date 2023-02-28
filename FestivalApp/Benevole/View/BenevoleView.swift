//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct BenevoleView: View {
    
    @ObservedObject private var benevole : Benevole
    private var intent : BenevoleIntent
    @State private var showModificationView : Bool = false
    
    init(benevole: Benevole) {
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
    }
    
    var body: some View {
        VStack {
            Text(benevole.nom)
            Text(benevole.prenom)
            Text(benevole.email)
            HStack {
                Button("Modifier") {
                    showModificationView = true
                }
                .sheet(isPresented: $showModificationView){
                    BenevoleModifView(benevole: benevole, intent: intent, create: false)
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


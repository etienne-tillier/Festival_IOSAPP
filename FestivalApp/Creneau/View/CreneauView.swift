//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct CreneauView: View {
    
    @ObservedObject private var creneau : Creneau
    private var zone : Zone
    private var intent : CreneauIntent
    @State private var showModificationView : Bool = false
    @State private var isConfimationPresented : Bool = false
    @Environment(\.presentationMode) var presentationMode
    private var delegate : ListDelegate?
    
    init(creneau: Creneau, zone : Zone) {
        self.zone = zone
        self.creneau = creneau
        self.intent = CreneauIntent(creneau: creneau)
        self.delegate = nil
    }
    
    init(creneau: Creneau, delegate : ListDelegate, zone : Zone) {
        self.zone = zone
        self.creneau = creneau
        self.intent = CreneauIntent(creneau: creneau)
        self.delegate = delegate
    }
    
    func removeCreneau(){
        if (delegate != nil){
            self.delegate?.didRemove(item: self.creneau)
        }
        self.intent.removeCreneau(zoneId: self.zone.id)
        self.presentationMode.wrappedValue.dismiss()
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
                Button("Supprimer") {
                    self.isConfimationPresented = true
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
                message: Text("Êtes-vous sûr de vouloir supprimer ce créneau ?"),
                primaryButton: .destructive(Text("Supprimer"), action: self.removeCreneau),
                secondaryButton: .cancel()
            )
            }
            
        }
    }
}


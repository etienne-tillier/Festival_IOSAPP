//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct CreneauView: View {
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject private var creneau : Creneau
    private var intent : CreneauIntent
    @State private var showModificationView : Bool = false
    @State private var isConfimationPresented : Bool = false
    @Environment(\.presentationMode) var presentationMode
    private var delegate : ListDelegate?
    
    init(creneau: Creneau, zone : Zone) {
        self.creneau = creneau
        self.intent = CreneauIntent(creneau: creneau)
        self.delegate = nil
    }
    
    init(creneau: Creneau, delegate : ListDelegate) {
        self.creneau = creneau
        self.intent = CreneauIntent(creneau: creneau)
        self.delegate = delegate
    }
    
    func removeCreneau() {
        Task {
            await self.intent.removeCreneau(zoneId: self.creneau.zoneId)
            switch self.creneau.state {
            case .error:
                self.error.message = "Erreur lors de la supression du créneau"
                self.error.isPresented = true
            case .ready:
                if (delegate != nil){
                    await self.delegate?.didRemove(item: self.creneau)
                }
            default:
                break
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack {
            Text(creneau.zoneNom)
            Text(creneau.benevole.nom)
            Text(creneau.benevole.prenom)
            Text(creneau.benevole.email)
            HStack{
                Text(creneau.dateDebut.convertToDate()! + " " + String(creneau.dateDebut.getHour()!) + "h")
                Text(" - ")
                Text(creneau.dateFin.convertToDate()! + " " + String(creneau.dateFin.getHour()!) + "h")
            }
            HStack {
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


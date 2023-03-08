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
    @State private var showAddCreneauView : Bool = false
    @State private var isConfimationPresented : Bool = false
    var delegate: ListDelegate?
    @Environment(\.presentationMode) var presentationMode
    
    init(benevole: Benevole) {
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
        self.delegate = nil
    }
    
    init(benevole: Benevole, delegate : ListDelegate) {
        self.delegate = delegate
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
    }
    
    func removeBenevole(){
        //confirm
        if (delegate != nil){
            self.delegate!.didRemove(item: self.benevole)
        }
        self.intent.removeBenevoleById(id: self.benevole.id)
        self.presentationMode.wrappedValue.dismiss()
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
                NavigationLink(destination: BenevoleListView(benevoles: BenevoleList())) {
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
                Button("Ajouter un créneau") {
                    showAddCreneauView = true
                }
                .sheet(isPresented: $showAddCreneauView){
                    CreneauCreateView(benevole: benevole)
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
            
        }.alert(isPresented: $isConfimationPresented) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Êtes-vous sûr de vouloir supprimer ce bénévole ?"),
                primaryButton: .destructive(Text("Supprimer"), action: self.removeBenevole),
                secondaryButton: .cancel()
            )
        }
    }
}


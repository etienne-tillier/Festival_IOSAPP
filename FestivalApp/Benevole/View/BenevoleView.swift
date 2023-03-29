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
    @State private var showListCreneauView : Bool = false
    @State private var showAddCreneauView : Bool = false
    @State private var isConfimationPresented : Bool = false
    @ObservedObject private var creneaux : CreneauList = CreneauList()
    var delegate: ListDelegate?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var zones: ZoneList
    
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
    
    
    func removeBenevole() {
        Task{
            if (delegate != nil){
                await self.delegate!.didRemove(item: self.benevole)
            }
            await self.intent.remove()
            switch self.benevole.state {
            case .removed:
                self.presentationMode.wrappedValue.dismiss()
            case .error:
                print("error")
            default:
                break
            }
        }

    }
    
    
    var body: some View {
        NavigationView{
            VStack {
                Text(benevole.nom)
                Text(benevole.prenom)
                Text(benevole.email)
                HStack {
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
                    Button("Creneaux") {
                        showListCreneauView = true
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

                if (showListCreneauView == true){
                    Button("Masquer") {
                        showListCreneauView = false
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
                    CreneauListBenevoleView(creneaux: creneaux, benevoleId: self.benevole.id)
                }
            }
            .alert(isPresented: $isConfimationPresented) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Êtes-vous sûr de vouloir supprimer ce bénévole ?"),
                    primaryButton: .destructive(Text("Supprimer"), action: self.removeBenevole),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


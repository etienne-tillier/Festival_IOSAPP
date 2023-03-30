//
//  BenevoleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct BenevoleView: View {
    
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject private var benevole : Benevole
    private var intent : BenevoleIntent
    @State private var showModificationView : Bool = false
    @State private var showListCreneauView : Bool = false
    @State private var showAddCreneauView : Bool = false
    @State private var isConfimationPresented : Bool = false
    @ObservedObject private var creneaux : CreneauList = CreneauList()
    var delegate: BenevoleListView?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var zones: ZoneList
    
    init(benevole: Benevole) {
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
        self.delegate = nil
    }
    
    init(benevole: Benevole, delegate : BenevoleListView) {
        self.delegate = delegate
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
    }
    
    
    func removeBenevole() {
        Task{
            await self.intent.remove(){ result in
                switch result {
                case .success(()):
                    if (delegate != nil){
                        self.delegate!.didRemove(item: self.benevole)
                    }
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    self.error.message = error.localizedDescription
                    self.error.isPresented = true

                    
                }
            }
        }

    }
    
    
    var body: some View {
        VStack {
            VStack {
                VStack{
                    Text(benevole.nom)
                        .padding(.vertical, 10)
                    Text(benevole.prenom)
                        .padding(.vertical, 10)
                    Text(benevole.email)
                        .padding(.vertical, 10)
                }
                .background(Color.white)
                .padding(.horizontal, 90)
                .border(.black)
                .cornerRadius(10)
                Spacer().frame(height: 40)
                if (showListCreneauView == false){
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
        }.alert(isPresented: $isConfimationPresented) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Êtes-vous sûr de vouloir supprimer ce bénévole ?"),
                        primaryButton: .destructive(Text("Supprimer"), action: self.removeBenevole),
                        secondaryButton: .cancel()
                    )
                }.toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            NavigationLink(destination: BenevoleListView(benevoles: BenevoleList())) {
                                Button(action: {
                                    withAnimation{
                                        self.isConfimationPresented = true
                                    }
                                }, label: {
                                    Image(systemName: "trash")
                                })
                            }
                        }
                    }
                }
            }
            
        }



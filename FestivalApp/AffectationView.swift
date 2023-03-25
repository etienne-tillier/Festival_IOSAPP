//
//  AffectationView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 24/03/2023.
//

import SwiftUI

struct AffectationView: View {
    
    @EnvironmentObject var user : Benevole
    @State private var action: Int? = 0
    @ObservedObject var benevole : Benevole = Benevole()
    @ObservedObject private var creneaux : CreneauList = CreneauList()
    //@State var benevoleIntent : BenevoleIntent
    
    init(user : Benevole){
        //self.benevoleIntent = BenevoleIntent(benevole: _benevole.wrappedValue)
        self.benevole = user
    }
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: BenevoleDispoListView(benevole: benevole), tag: 1, selection: $action) {
                EmptyView()
            }
            NavigationLink(destination: CreneauListBenevoleNoAdminView(creneaux: creneaux, benevoleId: benevole.id), tag: 2, selection: $action) {
                EmptyView()
            }
            VStack{
                Label("Mes dispos", systemImage: "calendar.badge.plus")
                    .onTapGesture {
                        self.action = 1
                    }
                Label("Mes affectations", systemImage: "mappin.and.ellipse")
                    .onTapGesture {
                        self.action = 2
                    }
            }
            .navigationTitle("Mes affectations")
        }.onAppear{
            print("yessssaaaaai")
            self.action = 0
        }
    }
}

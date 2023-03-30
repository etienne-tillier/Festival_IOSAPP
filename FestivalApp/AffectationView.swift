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
        self.action = 0
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
                VStack{
                    Image(systemName: "calendar.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("Mes dispos")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 120)
                .padding(.vertical, 60)
                .border(.black)
                .onTapGesture {
                    self.action = 1
                }
                Spacer().frame(height: 40)
                VStack{
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("Mes affectations")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 100)
                .padding(.vertical, 60)
                .border(.black)
                .onTapGesture {
                    self.action = 2
                }
            }
        }.onAppear{
            self.action = 0
        }
    }
}

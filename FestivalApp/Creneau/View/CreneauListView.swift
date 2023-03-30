//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct CreneauListView : View, ListDelegate {
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var creneaux : CreneauList
    private var intent : CreneauListIntent
    @ObservedObject var festival : Festival
    @State private var showAddView : Bool = false
    @State private var showAddZone : Bool = false
    @ObservedObject private var zone : Zone
    @State private var showModifZone : Bool = false
    
    init(creneaux: CreneauList, zone : Zone, festival : Festival) {
        self.zone = zone
        self.creneaux = creneaux
        self.intent = CreneauListIntent(creneaux: creneaux)
        self.festival = festival
    }
    
    func didRemove(item: Object) async {
        let creneau = item as! Creneau
        let index = self.creneaux.creneaux.firstIndex(where: { $0 == creneau })
        await self.intent.remove(index: IndexSet(integer: index!))
        switch self.creneaux.state {
        case.error:
            self.error.message = "Erreur lors de la suppression du créneau"
            self.error.isPresented = true
        default:
            break
        }
    }
    
    func didAdd(creneau : Creneau){
        self.creneaux.state = .add(creneau)
    }
    
    
    
    var body: some View {
            VStack{
                
                List{
                    ForEach(creneaux.creneaux, id: \.self){
                        creneau in
                        //NavigationLink(destination: CreneauView(creneau: creneau, delegate: self)) {
                        CreneauListItem(creneau: creneau, isBenevole: false)
                    }.onDelete{
                        indexSet in
                        Task {
                          await intent.remove(index: indexSet)
                        }
                    }
                }
                .sheet(isPresented: $showAddView){
                    CreneauZoneCreateView(zone: zone, delegate : self, festi: self.festival)
                }
                Button("Modifier la zone") {
                    self.showModifZone = true
                }
                .sheet(isPresented: $showModifZone){
                    ZoneModifView(zone: self.zone)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }.navigationTitle("Créneaux occupés")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation{
                                self.showAddView = true
                            }
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
        }
    
}

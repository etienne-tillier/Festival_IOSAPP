//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct CreneauListView : View, ListDelegate {
    
    @ObservedObject var creneaux : CreneauList
    private var intent : CreneauListIntent
    @State private var showAddView : Bool = false
    @ObservedObject private var zone : Zone
    
    init(creneaux: CreneauList, zone : Zone) {
        self.zone = zone
        self.creneaux = creneaux
        self.intent = CreneauListIntent(creneaux: creneaux)
    }
    
    func didRemove(item: Object) async {
        let creneau = item as! Creneau
        let index = self.creneaux.creneaux.firstIndex(where: { $0 == creneau })
        await self.intent.remove(index: IndexSet(integer: index!))
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
                    CreneauZoneCreateView(zone: zone, delegate : self)
                }
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

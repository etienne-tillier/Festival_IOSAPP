//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct CreneauListBenevoleNoAdminView : View, ListDelegate {
    
    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var creneaux : CreneauList
    private var intent : CreneauListIntent
    @State private var benevoleId : String
    
    init(creneaux: CreneauList, benevoleId : String) {
        self.creneaux = creneaux
        self.benevoleId = benevoleId
        self.intent = CreneauListIntent(creneaux: creneaux)
    }
    
    
    func didRemove(item: Object) async {
        let creneau = item as! Creneau
        let index = self.creneaux.creneaux.firstIndex(where: { $0.dateDebut == creneau.dateDebut && $0.benevole.id == creneau.benevole.id })
        await self.intent.remove(index: IndexSet(integer: index!))
        switch self.creneaux.state {
        case .error:
            self.error.message = "Erreur lors de la suppression du créneau"
            self.error.isPresented = true
        default:
            break
        }
    }
    
    
    
    
    
    func getCreneauxForBenevole() async {
        await self.intent.getCreneauxForBenevole(benevoleId: self.benevoleId)
        switch self.creneaux.state {
        case .error:
            self.error.message = "Erreur lors de la récupération des créneaux"
            self.error.isPresented = true
        default:
            break
        }
    }
    
    
    
    var body: some View {
        VStack{
            List{
                ForEach(creneaux.creneaux, id: \.self){ creneau in
                    CreneauListItem(creneau: creneau, isBenevole: true)
                }
            }.onAppear{
                Task {
                    await self.getCreneauxForBenevole()
                }
            }.navigationTitle("Mes créneaux")
        }
        
    }
}

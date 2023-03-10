//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct CreneauListBenevoleView : View, ListDelegate {
    
    @ObservedObject var creneaux : CreneauList
    private var intent : CreneauListIntent
    @State private var showCreneau : Bool = false
    @StateObject private var selectedCreneau : Creneau = Creneau()
    
    init(creneaux: CreneauList) {
        self.creneaux = creneaux
        self.intent = CreneauListIntent(creneaux: creneaux)
    }
    
    func didRemove(item: Object) {
        let creneau = item as! Creneau
        let index = self.creneaux.creneaux.firstIndex(where: { $0 == creneau })
        self.intent.remove(index: IndexSet(integer: index!))
    }
    
    
    
    var body: some View {
            VStack{
                List{
                    ForEach(creneaux.creneaux, id: \.self){ creneau in
                        Button(action: {
                            self.selectedCreneau.setValue(creneau: creneau)
                            self.showCreneau = true
                        }) {
                            CreneauListItem(creneau: creneau, isBenevole: true)
                        }
                    }.onDelete{
                        indexSet in
                        intent.remove(index: indexSet)
                    }
                }
                .sheet(isPresented: $showCreneau){
                    CreneauView(creneau: selectedCreneau, delegate: self)
                }
                
                HStack{
                    EditButton()
                }
            }
    }
    
}

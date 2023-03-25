//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleListView: View, ListDelegate {

    
    
    @ObservedObject var benevoles : BenevoleList
    private var intent : BenevoleListIntent
    @State private var showAddView : Bool = false
    @State private var searchText : String = ""
    var searchResults: [Benevole] {
         if searchText.isEmpty {
             return self.benevoles.benevoles
         } else {
             return self.benevoles.benevoles.filter { $0.nom.contains(searchText) || $0.prenom.contains(searchText)}
         }
     }
    
    init(benevoles: BenevoleList) {
        self.benevoles = benevoles
        self.intent = BenevoleListIntent(benevoles: benevoles)
    }
    
    func didRemove(item: Object) {
        let benevole = item as! Benevole
        let index = self.benevoles.benevoles.firstIndex(where: { $0 == benevole })
        Task{
            await self.intent.remove(index: IndexSet(integer: index!))
        }
    }
    
    
    var body: some View {
            VStack{
                List{
                    ForEach(searchResults, id: \.self){
                        benevole in
                        NavigationLink(destination: BenevoleView(benevole: benevole, delegate: self)) {
                            BenevoleListItem(benevole: benevole)
                        }
                    }.onDelete{
                        indexSet in
                        Task {
                            await intent.remove(index: indexSet)
                        }
                    }
                }
                .refreshable {
                    Task {
                        await self.intent.loadBenevoles()
                    }
                }
                .sheet(isPresented: $showAddView){
                    BenevoleCreateView(benevoles: benevoles, intent: intent)
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Chercher un bénévole")
                .navigationTitle("Bénévoles")
            }
    }
    
}

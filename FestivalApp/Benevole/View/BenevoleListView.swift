//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleListView: View, ListDelegate {

    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var benevoles : BenevoleList
    private var intent : BenevoleListIntent
    @State private var showAddView : Bool = false
    @State private var searchText : String = ""
    @State private var indexSetToRemove : IndexSet = IndexSet(integer: 0)
    @State private var isConfimationPresented : Bool = false
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
        self.benevoles.state = .remove(IndexSet(integer: index!))
        switch self.benevoles.state {
        case .error:
            self.error.message = "Erreur lors de la suppression du bénévole"
            self.error.isPresented = true
        default:
            break
        }
    }
    
    func removeBenevole(){
        Task {
            await self.intent.remove(index: indexSetToRemove)
            switch self.benevoles.state {
            case .error:
                self.error.message = "Erreur lors de la suppression du bénévole"
                self.error.isPresented = true
            default:
                break
            }
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
                        self.indexSetToRemove = indexSet
                        self.isConfimationPresented = true
                    }
                }
                .alert(isPresented: $isConfimationPresented) {
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Êtes-vous sûr de vouloir supprimer définitivement ce bénévole ?"),
                                primaryButton: .destructive(Text("Supprimer"), action: self.removeBenevole),
                                secondaryButton: .cancel()
                            )
                        }
                .refreshable {
                    Task {
                        await self.intent.loadBenevoles()
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Chercher un bénévole")
                .navigationTitle("Bénévoles")
            }
    }
    
}

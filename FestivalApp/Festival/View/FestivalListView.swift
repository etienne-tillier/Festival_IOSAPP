//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct FestivalListView: View, ListDelegate {

    
    @EnvironmentObject var error : ErrorObject
    @ObservedObject var festivals : FestivalList
    private var intent : FestivalListIntent
    @State private var showAddView : Bool = false
    @State private var searchText : String = ""
    @State private var indexToRemove : IndexSet = IndexSet(integer: 0)
    @State private var isConfimationPresented : Bool = false
    var searchResults: [Festival] {
         if searchText.isEmpty {
             return self.festivals.festivals
         } else {
             return self.festivals.festivals.filter { $0.nom.contains(searchText)}
         }
     }
    
    init(festivals: FestivalList) {
        self.festivals = festivals
        self.intent = FestivalListIntent(festivals: festivals)
    }
    
    func didRemove(item: Object) {
        let festival = item as! Festival
        let index = self.festivals.festivals.firstIndex(where: { $0 == festival })
        Task{
            await self.intent.remove(index: IndexSet(integer: index!))
        }
    }
    
    func removeFestival() {
        Task {
            await intent.remove(index: indexToRemove)
            switch self.festivals.state {
            case .error:
                self.error.message = "Erreur de suppresion du festival"
                self.error.isPresented = true
            default:
                break;
            }
        }
    }

    
    var body: some View {
            VStack{
                List{
                    ForEach(searchResults, id: \.self){
                        festival in
                        NavigationLink(destination: AdminZoneView(zones: ZoneList(zones: festival.zones), festival : festival)) {
                            Text(festival.nom);
                        }
                    }.onDelete{
                        indexSet in
                            self.indexToRemove = indexSet
                            self.isConfimationPresented = true
                    }
                }
                .alert(isPresented: $isConfimationPresented) {
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Êtes-vous sûr de vouloir supprimer définitivement ce festival ?"),
                                primaryButton: .destructive(Text("Supprimer"), action: self.removeFestival),
                                secondaryButton: .cancel()
                            )
                        }
                .refreshable {
                    Task {
                        await self.intent.loadFestivals()
                    }
                }
                
                .sheet(isPresented: $showAddView){
                    FestivalAddView(festivals: self.festivals)
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Chercher un festival")
                .navigationTitle("Festivals")
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
    
}

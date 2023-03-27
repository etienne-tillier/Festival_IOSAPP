//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct FestivalListView: View, ListDelegate {

    
    
    @ObservedObject var festivals : FestivalList
    private var intent : FestivalListIntent
    @State private var showAddView : Bool = false
    @State private var searchText : String = ""
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
                        Task {
                            await intent.remove(index: indexSet)
                        }
                    }
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

//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleAvailableView : View {

    
    
    @ObservedObject var benevoles : BenevoleList
    private var intent : BenevoleListIntent
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
    
    
    
    var body: some View {
            VStack{
                Text("Bénévoles disponibles")
                List{
                    ForEach(searchResults, id: \.self){
                        benevole in
                        NavigationLink(value: benevole) {
                            BenevoleListItem(benevole: benevole)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Chercher un bénévole")
            }
    }
    
}

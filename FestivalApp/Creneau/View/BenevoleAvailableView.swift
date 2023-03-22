//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleAvailableView : View {

    
    
    @ObservedObject var benevoles : BenevoleList
    @ObservedObject var chosenBenevole : Benevole
    private var choosenBenevoleIntent : BenevoleIntent
    private var intent : BenevoleListIntent
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText : String = ""
    var searchResults: [Benevole] {
         if searchText.isEmpty {
             return self.benevoles.benevoles
         } else {
             return self.benevoles.benevoles.filter { $0.nom.contains(searchText) || $0.prenom.contains(searchText)}
         }
     }
    
    init(benevoles: BenevoleList, chosenBenevole : Benevole) {
        self.benevoles = benevoles
        self.intent = BenevoleListIntent(benevoles: benevoles)
        self.chosenBenevole = chosenBenevole
        self.choosenBenevoleIntent = BenevoleIntent(benevole: chosenBenevole)
    }
    
    
    
    var body: some View {
            VStack{
                Text("Bénévoles disponibles")
                List{
                    ForEach(searchResults, id: \.self){
                        benevole in
                        BenevoleListItem(benevole: benevole)
                            .onTapGesture {
                                self.choosenBenevoleIntent.loadBenevoleData(benevole: benevole)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Chercher un bénévole")
            }
    }
    
}

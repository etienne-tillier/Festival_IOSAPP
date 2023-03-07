//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct CreneauListView : View {
    
    @ObservedObject var creneaux : CreneauList
    private var intent : CreneauListIntent
    @State private var showAddView : Bool = false
    private var selectedZone : Zone
    
    init(creneaux: CreneauList, selectedZone : Zone) {
        self.creneaux = creneaux
        self.selectedZone = selectedZone
        self.intent = CreneauListIntent(creneaux: creneaux, selectedZone: selectedZone)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(creneaux.creneaux, id: \.self){
                        creneau in
                        NavigationLink(value: creneau) {
                            CreneauListItem(creneau: creneau)
                        }
                    }.onDelete{
                        indexSet in
                            intent.remove(index: indexSet)
                    }
                }
                .sheet(isPresented: $showAddView){
                    //BenevoleCreateView(benevoles: benevoles, intent: intent)
                }
                .navigationDestination(for: Creneau.self){
                    creneau in
                    CreneauView(creneau: creneau)
                }
                HStack{
                    EditButton()
                    Button(action: {
                        withAnimation{
                            //self.showAddView = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }.navigationTitle("Créneaux occupés")
        }
        
    }
    
}

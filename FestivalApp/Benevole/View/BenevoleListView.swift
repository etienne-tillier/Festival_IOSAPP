//
//  BenevoleListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleListView: View {
    
    @ObservedObject var benevoles : BenevoleList
    private var intent : BenevoleListIntent
    
    init(benevoles: BenevoleList) {
        self.benevoles = benevoles
        self.intent = BenevoleListIntent(benevoles: benevoles)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(benevoles.benevoles, id: \.self){
                        benevole in
                        NavigationLink(value: benevole) {
                            BenevoleListItem(benevole: benevole)
                        }
                    }.onDelete{
                        indexSet in
                        Task{
                            await intent.remove(index: indexSet)
                        }
                    }
                }
                .navigationDestination(for: Benevole.self){
                    benevole in
                    BenevoleView(benevole: benevole)
                }
                EditButton()
            }.navigationTitle("Bénévoles")
        }
        
    }
    
}

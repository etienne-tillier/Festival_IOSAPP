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
    @State private var showAddView : Bool = false
    
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
                            intent.remove(index: indexSet)
                    }
                }
                .sheet(isPresented: $showAddView){
                    BenevoleCreateView(benevoles: benevoles, intent: intent)
                }
                .navigationDestination(for: Benevole.self){
                    benevole in
                    BenevoleView(benevole: benevole)
                }
                HStack{
                    EditButton()
                    Button(action: {
                        withAnimation{
                            self.showAddView = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }.navigationTitle("Bénévoles")
        }
        
    }
    
}

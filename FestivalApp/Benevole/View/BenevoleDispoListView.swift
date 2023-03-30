//
//  BenevoleDispoListView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 24/03/2023.
//

import SwiftUI

struct BenevoleDispoListView: View {
    
    
    @EnvironmentObject var error : ErrorObject
    @State var benevoleIntent : BenevoleIntent? = nil
    @State var showAddView : Bool = false
    @ObservedObject var user : Benevole
    
    init(benevole : Benevole){
        self.user = benevole
    }
    
    
    
    var body: some View {
        VStack{
            List{
                ForEach(user.dispo, id: \.self){
                    dispo in
                    HStack{
                        Text(dispo[0].convertToDate()!)
                        Text(" ")
                        Text(String(dispo[0].getHour()!) + "h")
                        Text(" - ")
                        Text(String(dispo[1].getHour()!) + "h")
                    }
                }
                .onDelete{
                    indexSet in
                    Task {
                        await benevoleIntent!.removeDispo(index: indexSet)
                        switch self.user.state {
                        case .error:
                            self.error.message = "Erreur de la suppression de la dispo"
                            self.error.isPresented = true
                        default:
                            break
                        }
                    }
                     
                }
            }
            .sheet(isPresented: $showAddView){
                BenevoleDispoAddView(benevole : user)
            }
            .navigationTitle("Mes dispos")
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
        }.onAppear{
            self.benevoleIntent = BenevoleIntent(benevole: self.user)
        }
    }
}

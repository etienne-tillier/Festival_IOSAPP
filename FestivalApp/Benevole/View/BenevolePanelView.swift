//
//  ContentView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI

struct BenevolePanelView : View {
    
    
    @ObservedObject private var benevoles : BenevoleList
    @State private var intent : BenevoleListIntent

    
    init(benevoles : BenevoleList){
        self.benevoles = benevoles
        self.intent = BenevoleListIntent(benevoles: benevoles)
    }

    
    var body: some View {
        VStack {
            switch benevoles.state {
                case .isLoading :
                    ProgressView()
                case .ready :
                    BenevoleListView(benevoles: benevoles)
                case .load(_):
                    Text("C'est chargé")
                case .updated:
                    Text("updated")
                case .error:
                    Text("erreur")
            default:
                ProgressView()
            }
        }.onAppear {
            self.intent.loadBenevoles()
        }
        
    }

}


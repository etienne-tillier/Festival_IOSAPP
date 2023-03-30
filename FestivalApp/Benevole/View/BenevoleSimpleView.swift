//
//  BenevoleSimpleView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 15/03/2023.
//

import SwiftUI

struct BenevoleSimpleView: View {
    
    @ObservedObject var benevole : Benevole
    @EnvironmentObject var error : ErrorObject
    
    init (benevole : Benevole){
        self.benevole = benevole
    }
    
    
    var body: some View {
        HStack {
            Text(benevole.nom)
            Text(benevole.prenom)
        }
    }
}

//
//  BenevoleListItem.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import SwiftUI

struct BenevoleListItem: View {
    
    @ObservedObject var benevole : Benevole
    private var intent : BenevoleIntent
    
    init(benevole: Benevole) {
        self.benevole = benevole
        self.intent = BenevoleIntent(benevole: benevole)
    }
    
    var body: some View {
        HStack {
            Text(benevole.nom)
            Text(benevole.prenom)
        }
    }
}


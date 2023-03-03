//
//  CreneauListItem.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 02/03/2023.
//

import SwiftUI

struct CreneauListItem: View {
    
    @ObservedObject var creneau : Creneau
    
    init(creneau: Creneau) {
        self.creneau = creneau
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(creneau.benevole.nom)
                Text(creneau.benevole.prenom)
            }
            HStack{
                Text(creneau.dateDebut.convertToDate()! + " " + String(creneau.dateDebut.getHour()!) + "h")
                Text(" - ")
                Text(creneau.dateFin.convertToDate()! + " " + String(creneau.dateFin.getHour()!) + "h")
            }
        }

    }
}

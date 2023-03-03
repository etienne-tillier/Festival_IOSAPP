//
//  BenevoleListIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI


struct CreneauListIntent {
    
    private var creneaux : CreneauList
    private var dao : ZoneDAO = ZoneDAO()
    private var selectedZone : Zone
    
    init(creneaux: CreneauList, selectedZone : Zone) {
        self.creneaux = creneaux
        self.selectedZone = selectedZone
    }
    
    func remove(index : IndexSet) async {
        DispatchQueue.main.async {
            self.creneaux.state = .remove(index)
            self.creneaux.state = .ready
        }
        do {
            await dao.removeCreneauFromZone(zoneId: selectedZone.id, creneau: creneaux.creneaux[index.first!]) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.creneaux.state = .error
                    }
                case .success():
                    print("Le Créneau a été supprimé avec succès !")
                }
            }
        }

    }
    
    
    
    
    
}

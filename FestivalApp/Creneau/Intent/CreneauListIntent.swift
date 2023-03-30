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
    
    init(creneaux: CreneauList) {
        self.creneaux = creneaux
        
    }
    
    func remove(index : IndexSet) async {
        do {
            await dao.removeCreneauFromZone(zoneId: self.creneaux.creneaux[index.first!].zoneId, creneau: self.creneaux.creneaux[index.first!]) { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        self.creneaux.state = .error
                    }
                case .success():
                    DispatchQueue.main.async {
                        self.creneaux.state = .remove(index)
                        self.creneaux.state = .ready
                    }
                }
            }
        }

    }
    
    func getCreneauxForBenevole(benevoleId : String) async {
        DispatchQueue.main.async {
            self.creneaux.state = .isLoading
        }
        await self.dao.getCreneauByBenevole(benevoleId: benevoleId) { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.creneaux.state = .error
                }
            case .success(let creneaux):
                DispatchQueue.main.async {
                    self.creneaux.state = .load(creneaux)
                    self.creneaux.state = .ready
                }
            }
        }
    }


    
    
    
    
}

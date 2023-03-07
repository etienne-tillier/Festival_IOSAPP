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
    
    func remove(index : IndexSet) {
        self.setSelectedZone(zone: self.selectedZone)
        self.creneaux.state = .remove(index)
    }
    
    func setSelectedZone(zone : Zone){
        self.creneaux.state = .setSelectedZone(zone)
    }
    
    
    
    
    
}

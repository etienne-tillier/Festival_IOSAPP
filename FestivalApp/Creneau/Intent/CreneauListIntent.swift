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
    
    func remove(index : IndexSet) {
        self.creneaux.state = .remove(index)
    }

    
    
    
    
}

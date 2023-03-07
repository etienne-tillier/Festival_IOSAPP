//
//  BenevoleListIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI


struct ZoneListIntent {
    
    private var zones : ZoneList
    private var dao : ZoneDAO = ZoneDAO()
    
    init(zones: ZoneList) {
        self.zones = zones
    }
    
    func getAllZone() {
        self.zones.state = .isLoading
    }
    
    
    
    
}

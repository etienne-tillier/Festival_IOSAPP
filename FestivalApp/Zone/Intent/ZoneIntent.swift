//
//  ZoneIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

struct ZoneIntent {
    
    private var zone : Zone
    private var dao : ZoneDAO = ZoneDAO()
    
    init(zone: Zone) {
        self.zone = zone
    }
    
    init(){
        self.zone = Zone()
    }
    
    func load(zone : Zone){
        self.zone.state = .isLoading
        self.zone.state = .load(zone)
        self.zone.state = .ready
    }
    
    
    
}

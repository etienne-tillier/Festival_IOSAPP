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
    
    
    
}

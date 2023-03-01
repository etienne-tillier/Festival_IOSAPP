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
    
    func getAllZone() async {
        do {
            DispatchQueue.main.async {
                zones.state = .isLoading
            }
            await dao.getAllZones() { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        zones.state = .error
                    }
                case .success(let newZones):
                    DispatchQueue.main.async {
                        zones.state = .load(newZones)
                        zones.state = .ready
                    }
                }
            }
            
        }
    }
    
    
    
    
}

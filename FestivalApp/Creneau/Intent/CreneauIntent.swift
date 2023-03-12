//
//  ZoneIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

struct CreneauIntent {
    
    private var creneau : Creneau
    private var dao : ZoneDAO = ZoneDAO()
    
    init(creneau : Creneau) {
        self.creneau = creneau
    }
    
    
    func removeCreneau(zoneId : String) async {
        await dao.removeCreneauFromZone(zoneId: zoneId, creneau: self.creneau){ result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.creneau.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.creneau.state = .ready
                }
            }
        }
    }
    
    
    
}

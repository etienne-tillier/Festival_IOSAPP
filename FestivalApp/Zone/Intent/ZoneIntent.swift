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
    

    
    func addCreneau(benevole : Benevole, date : Date, heureDebut : Int, heureFin : Int) async {
        self.zone.state = .isLoading
        let creneau : (Date, Date) = getStartAndEndDates(forDay: date, startHour: heureDebut, endHour: heureFin)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDateString = dateFormatter.string(from: creneau.0)
        let endDateString = dateFormatter.string(from: creneau.1)
        await dao.addCreneauToZone(zoneId: self.zone.id, benevoleId: benevole.id, dateDebut: startDateString, dateFin: endDateString) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.zone.state = .error
            case .success():
                self.zone.state = .ready
            }
        }
        
    }
    
    
    
}

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
    
    func getStartAndEndDates(forDay day: Date, startHour: Int, endHour: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current

        // Extract the year, month, and day components from the given day date
        //let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)

        // Create date components for the start hour
        var startComponents = DateComponents()
        startComponents.hour = startHour
        startComponents.minute = 0

        // Create date components for the end hour
        var endComponents = DateComponents()
        endComponents.hour = endHour
        endComponents.minute = 0

        // Combine the day components with the start/end hour components to create the start/end dates
        if let startDate = calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: day),
           let endDate = calendar.date(bySettingHour: endHour, minute: 0, second: 0, of: day) {
            return (startDate, endDate)
        } else {
            return nil
        }
    }

    
    func addCreneau(benevole : Benevole, date : Date, heureDebut : Int, heureFin : Int) async {
        let creneau : (Date, Date) = getStartAndEndDates(forDay: date, startHour: heureDebut, endHour: heureFin)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDateString = dateFormatter.string(from: creneau.0)
        let endDateString = dateFormatter.string(from: creneau.1)
        await dao.addCreneauToZone(zoneId: self.zone.id, benevoleId: benevole.id, dateDebut: startDateString, dateFin: endDateString) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.zone.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.zone.state = .addCreneau(Creneau(benevole: benevole, dateDebut: startDateString, dateFin: endDateString, zoneNom: self.zone.nom, zoneId: self.zone.id))
                    self.zone.state = .ready
                }
            }
        }
    }
    
    
    
}

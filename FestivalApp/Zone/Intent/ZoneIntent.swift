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
    


    
    func addCreneau(benevole : Benevole, date : Date, heureDebut : Int, heureFin : Int, completion: @escaping (Result<Creneau,Error>) -> Void) async {
        let creneau : (Date, Date) = Tools.getStartAndEndDates(forDay: date, startHour: heureDebut, endHour: heureFin)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDateString = dateFormatter.string(from: creneau.0)
        let endDateString = dateFormatter.string(from: creneau.1)
        DispatchQueue.main.async {
            self.zone.state = .isLoading
        }
        await dao.addCreneauToZone(zoneId: self.zone.id, benevoleId: benevole.id, dateDebut: startDateString, dateFin: endDateString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                DispatchQueue.main.async {
                    self.zone.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    let creneau : Creneau = Creneau(benevole: benevole, dateDebut: startDateString, dateFin: endDateString, zoneNom: self.zone.nom, zoneId: self.zone.id)
                    self.zone.state = .addCreneau(creneau)
                    self.zone.state = .ready
                    completion(.success((creneau)))
                }
            }
        }
    }
    
    
    
}

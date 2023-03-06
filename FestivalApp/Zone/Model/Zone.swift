//
//  Zone.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum ZoneState : Equatable {
    case ready
    case isLoading
    case load(Zone)
    case error
}


class Zone : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    
    var dao : ZoneDAO = ZoneDAO()
    @Published var id : String
    @Published var nom : String
    @Published var creneaux : [Creneau]
    @Published var jeux : [Jeu]
    @Published var state : ZoneState = .isLoading{
        didSet{
            switch state {
            case .load(let zone):
                self.nom = zone.nom
                self.id = zone.id
                self.creneaux = zone.creneaux
                self.jeux = zone.jeux
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String, creneaux: [Creneau], jeux : [Jeu]) {
        self.id = id
        self.nom = nom
        self.creneaux = creneaux
        self.jeux = jeux
    }
    
    init(){
        self.id = ""
        self.nom = ""
        self.creneaux = []
        self.jeux = []
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom
        case creneaux = "benevoles"
        case jeux
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.creneaux = try container.decode([Creneau].self, forKey: .creneaux)
        self.jeux = try container.decode([Jeu].self, forKey: .jeux)
    }
    
    func getStartAndEndDates(forDay day: Date, startHour: Int, endHour: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current

        // Extract the year, month, and day components from the given day date
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)

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
        await dao.addCreneauToZone(zoneId: self.id, benevoleId: benevole.id, dateDebut: startDateString, dateFin: endDateString) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.state = .error
            case .success():
                self.state = .ready
            }
        }
        
    }
    
    
    
    static func == (lhs: Zone, rhs: Zone) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



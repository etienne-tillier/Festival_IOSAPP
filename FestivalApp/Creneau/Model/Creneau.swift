//
//  Creneau.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum CreneauState : Equatable {
    case ready
    case isLoading
    case removing(String)
    case load
    case update
    case error
}

class Creneau : Decodable, ObservableObject, Hashable, Identifiable, Object {
    
    var id : UUID
    private var dao : ZoneDAO = ZoneDAO()
    @Published var dateDebut : String
    @Published var dateFin : String
    @Published var benevole : Benevole
    @Published var state : CreneauState = .ready{
        didSet {
            switch state {
            case .removing(let zoneId):
                Task{
                    await self.remove(zoneId: zoneId)
                }
            default:
                break
            }
        }
    }
    
    
    private enum CodingKeys : String, CodingKey {
        case dateDebut = "heureDebut"
        case dateFin = "heureFin"
        case benevole
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateDebut = try container.decode(String.self, forKey: .dateDebut)
        self.dateFin = try container.decode(String.self, forKey: .dateFin)
        self.benevole = try container.decode(Benevole.self, forKey: .benevole)
        self.id = UUID()
    }
    
    init(benevole : Benevole, dateDebut : String, dateFin : String){
        self.id = UUID()
        self.benevole = benevole
        self.dateDebut = dateDebut
        self.dateFin = dateFin
    }
    
    func remove() async {
        
    }
    
    func remove(zoneId : String) async {
        await dao.removeCreneauFromZone(zoneId: zoneId, creneau: self){ result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success():
                DispatchQueue.main.async {
                    self.state = .ready
                }
            }
        }
    }
    
    static func == (lhs: Creneau, rhs: Creneau) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
}

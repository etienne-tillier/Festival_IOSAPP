//
//  Zone.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum FestivalState : Equatable {
    case ready
    case isLoading
    case load(Festival)
    case addZone(Zone)
    case error
}


class Festival : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    
    var dao : ZoneDAO = ZoneDAO()
    @Published var id : String
    @Published var nom : String
    @Published var dateDebut : String
    @Published var jours : [JourFestival]
    @Published var zones : [Zone]
    @Published var state : FestivalState = .isLoading{
        didSet{
            switch state {
            case .load(let festival):
                self.nom = festival.nom
                self.id = festival.id
                self.zones = festival.zones
                self.jours = festival.jours
            case .addZone(let zone):
                self.zones.append(zone)
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String, dateDebut: String, zones: [Zone], jours : [JourFestival]) {
        self.id = id
        self.nom = nom
        self.dateDebut = dateDebut
        self.zones = zones
        self.jours = jours
    }
    
    init(){
        self.id = ""
        self.nom = ""
        self.dateDebut = ""
        self.zones = []
        self.jours = []
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom = "name"
        case dateDebut = "beginningDate"
        case zones
        case jours = "days"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.dateDebut = try container.decode(String.self, forKey: .dateDebut)
        self.zones = try container.decode([Zone].self, forKey: .zones)
        self.jours = try container.decode([JourFestival].self, forKey: .jours)
    }
    
    
    
    
    static func == (lhs: Festival, rhs: Festival) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



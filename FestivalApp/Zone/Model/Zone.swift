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
    case addCreneau(Creneau)
    case error
}


class Zone : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    
    var dao : ZoneDAO = ZoneDAO()
    @Published var id : String
    @Published var nom : String
    @Published var creneaux : [Creneau]
    @Published var state : ZoneState = .isLoading{
        didSet{
            switch state {
            case .load(let zone):
                self.nom = zone.nom
                self.id = zone.id
                self.creneaux = zone.creneaux
            case .addCreneau(let creneau):
                self.creneaux.append(creneau)
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String, creneaux: [Creneau]) {
        self.id = id
        self.nom = nom
        self.creneaux = creneaux
    }
    
    init(){
        self.id = ""
        self.nom = ""
        self.creneaux = []
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom
        case creneaux = "benevoles"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.creneaux = try container.decode([Creneau].self, forKey: .creneaux)
    }
    
    
    
    
    static func == (lhs: Zone, rhs: Zone) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



//
//  Creneau.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

class Creneau : Decodable{
    
    var dateDebut : String
    var dateFin : String
    var benevole : Benevole
    
    
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
    }
}

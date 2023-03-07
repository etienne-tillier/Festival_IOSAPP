//
//  Creneau.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

class Creneau : Decodable, ObservableObject, Hashable, Identifiable{
    
    var id : UUID
    @Published var dateDebut : String
    @Published var dateFin : String
    @Published var benevole : Benevole
    
    
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
    
    static func == (lhs: Creneau, rhs: Creneau) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
}

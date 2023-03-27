//
//  Zone.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum JourFestivalState : Equatable {
    case ready
    case isLoading
    case error
}


class JourFestival : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    
    @Published var id : String
    @Published var nom : String
    @Published var debut : String
    @Published var fin : String
    @Published var state : JourFestivalState = .ready{
        didSet {
            switch state {
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String, debut: String, fin: String) {
        self.id = id
        self.nom = nom
        self.debut = debut
        self.fin = fin
    }
    
    init(){
        self.id = ""
        self.nom = ""
        self.debut = ""
        self.fin = ""
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom = "name"
        case debut = "openingTime"
        case fin = "closingTime"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.debut = try container.decode(String.self, forKey: .debut)
        self.fin = try container.decode(String.self, forKey: .fin)
    }
    
    
    
    
    static func == (lhs: JourFestival, rhs: JourFestival) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



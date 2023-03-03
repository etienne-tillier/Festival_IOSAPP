//
//  Benevole.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI

enum BenevoleState : Equatable {
    case ready
    case isLoading
    case load(String, String, String, String)
    case updated
    case error
}

class Benevole : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    var id : String
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    
    @Published var state : BenevoleState = .isLoading{
            didSet{
                switch state {
                case .load(let id, let nom, let prenom, let email):
                    self.id = id
                    self.nom = nom
                    self.prenom = prenom
                    self.email = email
                default:
                    break
                }
            }
        }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom
        case prenom
        case email
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.prenom = try container.decode(String.self, forKey: .prenom)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    
    init(id: String, nom: String, prenom: String, email: String) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
    }
    
    init() {
        self.id = ""
        self.nom = ""
        self.prenom = ""
        self.email = ""
    }
    
    func updateState() {
        objectWillChange.send()
    }
    
    static func == (lhs: Benevole, rhs: Benevole) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
}

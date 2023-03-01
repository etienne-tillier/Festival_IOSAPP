//
//  Zone.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum JeuState : Equatable {
    case ready
    case isLoading
    case load(Jeu)
    case error
}


class Jeu : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    @Published var id : String
    @Published var nom : String
    @Published var type : TypeJeu?
    @Published var state : JeuState = .isLoading{
        didSet{
            switch state {
            case .load(let jeu):
                self.nom = jeu.nom
                self.id = jeu.id
                self.type = jeu.type
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String, type : TypeJeu) {
        self.id = id
        self.nom = nom
        self.type = type
    }
    
    init(){
        self.id = ""
        self.nom = ""
        self.type = nil
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.type = try container.decode(TypeJeu.self, forKey: .type)
    }
    
    static func == (lhs: Jeu, rhs: Jeu) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



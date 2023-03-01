//
//  Zone.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum TypeJeuState : Equatable {
    case ready
    case isLoading
    case load(TypeJeu)
    case error
}


class TypeJeu : Identifiable, ObservableObject, Decodable, Hashable, Equatable {
    
    @Published var id : String
    @Published var nom : String
    @Published var state : TypeJeuState = .isLoading{
        didSet{
            switch state {
            case .load(let typeJeu):
                self.nom = typeJeu.nom
                self.id = typeJeu.id
            default:
                break
            }
        }
    }
    
    init(id: String, nom: String) {
        self.id = id
        self.nom = nom
    }
    
    init(){
        self.id = ""
        self.nom = ""
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case nom
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
    }
    
    static func == (lhs: TypeJeu, rhs: TypeJeu) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
}



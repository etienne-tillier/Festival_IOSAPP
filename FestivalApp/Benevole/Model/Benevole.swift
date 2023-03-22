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
    case removing
    case removed
    case load(Benevole)
    case update(String, String, String)
    case error
}

class Benevole : Identifiable, ObservableObject, Codable, Hashable, Equatable, Object {
    
    var id : String
    var dao : BenevoleDAO = BenevoleDAO()
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    @Published var dispo : [[String]]
    @Published var admin : Bool
    
    @Published var state : BenevoleState = .ready{
            didSet{
                switch state {
                case .load(let benevole):
                    self.id = benevole.id
                    self.nom = benevole.nom
                    self.prenom = benevole.prenom
                    self.email = benevole.email
                    self.dispo = benevole.dispo
                    self.admin = benevole.admin
                case .update(let nom, let prenom, let email):
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
        case dispo
        case admin
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(nom, forKey: .nom)
        try container.encode(prenom, forKey: .prenom)
        try container.encode(email, forKey: .email)
        try container.encode(dispo, forKey: .dispo)
        try container.encode(admin, forKey: .admin)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nom = try container.decode(String.self, forKey: .nom)
        self.prenom = try container.decode(String.self, forKey: .prenom)
        self.email = try container.decode(String.self, forKey: .email)
        self.dispo = try container.decode([[String]].self, forKey: .dispo)
        self.admin = try container.decode(Bool.self, forKey: .admin)
    }
    
    
    init(id: String, nom: String, prenom: String, email: String, admin: Bool, dispo : [[String]]) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.admin = admin
        self.dispo = dispo
    }
    
    init() {
        self.id = ""
        self.nom = ""
        self.prenom = ""
        self.email = ""
        self.admin = false
        self.dispo = []
    }
    

  
    /*
    func loadBenevoleById(id : String) async {
        do {
            let newBenevole : Benevole = try await dao.getBenevolebyId(id: id)!
            DispatchQueue.main.async {
                self.state = .load(newBenevole.id, newBenevole.nom, newBenevole.prenom, newBenevole.email)
                self.state = .ready
            }
        }
        catch {
            print(error)
            DispatchQueue.main.async {
                self.state = .error
            }
        }
    }
     */
    
    
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

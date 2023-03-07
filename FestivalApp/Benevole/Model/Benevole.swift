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
    case load(String, String, String, String)
    case update(String, String, String)
    case error
}

class Benevole : Identifiable, ObservableObject, Codable, Hashable, Equatable {
    
    var id : String
    var dao : BenevoleDAO = BenevoleDAO()
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    
    @Published var state : BenevoleState = .isLoading{
            didSet{
                switch state {
                case .removing:
                    Task{
                        await self.remove()
                    }
                case .load(let id, let nom, let prenom, let email):
                    self.id = id
                    self.nom = nom
                    self.prenom = prenom
                    self.email = email
                case .update(let nom, let prenom, let email):
                    Task{
                        await self.updateBenevole(nom: nom, prenom: prenom, email: email)
                    }
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
    
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(nom, forKey: .nom)
            try container.encode(prenom, forKey: .prenom)
            try container.encode(email, forKey: .email)
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
    
    func remove() async {
        await dao.removeBenevoleById(id: self.id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success():
                print("benevole removed")
            }
        }
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
    
    func updateBenevole(nom: String, prenom: String, email: String) async {
        do {
            
            //api
            await dao.updateBenevole(id: self.id, nom: nom, prenom: prenom, email: email) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.state = .error
                    }
                case .success():
                    DispatchQueue.main.async {
                        self.state = .load(self.id, nom, prenom, email)
                        self.state = .ready
                    }
                }
            }

        }
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

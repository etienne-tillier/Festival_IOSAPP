//
//  Creneau.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

enum CreneauState : Equatable {
    case ready
    case isLoading
    case removing(String)
    case load
    case update
    case error
}

class Creneau : Decodable, ObservableObject, Hashable, Identifiable, Object {
    
    var id : UUID
    private var dao : ZoneDAO = ZoneDAO()
    @Published var dateDebut : String
    @Published var dateFin : String
    @Published var benevole : Benevole
    @Published var zoneId : String
    @Published var zoneNom : String
    @Published var state : CreneauState = .ready{
        didSet {
            switch state {
            default:
                break
            }
        }
    }
    
    
    private enum CodingKeys : String, CodingKey {
        case dateDebut = "heureDebut"
        case dateFin = "heureFin"
        case benevole
        case zoneNom = "zoneName"
        case zoneId = "zoneId"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateDebut = try container.decode(String.self, forKey: .dateDebut)
        self.dateFin = try container.decode(String.self, forKey: .dateFin)
        self.benevole = try container.decode(Benevole.self, forKey: .benevole)
        self.id = UUID()
        guard let zone : String = try? container.decode(String.self, forKey: .zoneNom) else {
            self.zoneNom = ""
            self.zoneId = ""
            return
        }
        self.zoneNom = zone
        self.zoneId = try container.decode(String.self, forKey: .zoneId)


    }
    
    
    
    init(benevole : Benevole, dateDebut : String, dateFin : String, zoneNom : String, zoneId : String){
        self.id = UUID()
        self.benevole = benevole
        self.dateDebut = dateDebut
        self.dateFin = dateFin
        self.zoneId = zoneId
        self.zoneNom = zoneNom
    }
    
    init(){
        self.id = UUID()
        self.benevole = Benevole()
        self.dateDebut = ""
        self.dateFin = ""
        self.zoneId = ""
        self.zoneNom = ""
    }
    
    func setValue(creneau : Creneau){
        self.benevole = creneau.benevole
        self.dateDebut = creneau.dateDebut
        self.dateFin = creneau.dateFin
        self.zoneId = creneau.zoneId
        self.zoneNom = creneau.zoneNom
    }
    
    func setZone(zone : Zone){
        self.zoneId = zone.id
        self.zoneNom = zone.nom
    }
    

    
    static func == (lhs: Creneau, rhs: Creneau) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
}

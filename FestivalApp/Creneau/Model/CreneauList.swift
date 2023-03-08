//
//  BenevoleList.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI

enum CreneauListState {
    case ready
    case isLoading
    case load([Creneau])
    case setSelectedZone(Zone)
    case remove(IndexSet)
    case add(Creneau)
    case updated
    case error
}
//a generaliser
class CreneauList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    private var dao : ZoneDAO = ZoneDAO()
    @Published var selectedZone : Zone
    @Published var creneaux : [Creneau]
    @Published var state : CreneauListState = .isLoading {
        didSet{
            switch state {
            case .load(let creneaux):
                self.creneaux = creneaux
            case .setSelectedZone(let zone):
                self.selectedZone = zone
            case .remove(let index):
                Task{
                    await self.remove(index: index)
                }
            case .add(let creneau):
                self.creneaux.append(creneau)
            default:
                break
            }
        }
    }
    
    init(creaneaux : [Creneau]){
        self.creneaux = creaneaux
        self.selectedZone = Zone()
        self.id = UUID()
    }
    
    
    init(){
        self.creneaux = []
        self.selectedZone = Zone()
        self.id = UUID()
    }
    

    func remove(index : IndexSet) async {
        do {
            await dao.removeCreneauFromZone(zoneId: self.selectedZone.id, creneau: self.creneaux[index.first!]) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.state = .error
                    }
                case .success():
                    self.creneaux.remove(at: index.first!)
                    print("Le Créneau a été supprimé avec succès !")
                }
            }
        }

    }
    
    static func == (lhs: CreneauList, rhs: CreneauList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

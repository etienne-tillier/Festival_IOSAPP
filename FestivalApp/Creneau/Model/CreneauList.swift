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
    case remove(IndexSet)
    case add(Creneau)
    case updated
    case error
}
//a generaliser
class CreneauList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    private var dao : ZoneDAO = ZoneDAO()
    @Published var creneaux : [Creneau]
    @Published var state : CreneauListState = .isLoading {
        didSet{
            switch state {
            case .load(let creneaux):
                self.creneaux = creneaux
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
    
    init(creneaux : [Creneau]){
        self.creneaux = creneaux
        self.id = UUID()
    }
    
    
    init(){
        self.creneaux = []
        self.id = UUID()
    }
    

    func remove(index : IndexSet) async {
        do {
            await dao.removeCreneauFromZone(zoneId: self.creneaux[index.first!].zoneId, creneau: self.creneaux[index.first!]) { result in
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

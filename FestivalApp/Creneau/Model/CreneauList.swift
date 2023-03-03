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
    @Published var creneaux : [Creneau]
    @Published var state : CreneauListState = .isLoading {
        didSet{
            switch state {
            case .load(let creneaux):
                self.creneaux = creneaux
            case .remove(let index):
                self.creneaux.remove(atOffsets: index)
            case .add(let creneau):
                self.creneaux.append(creneau)
            default:
                break
            }
        }
    }
    
    init(creaneaux : [Creneau]){
        self.creneaux = creaneaux
        self.id = UUID()
    }
    
    
    init(){
        self.creneaux = []
        self.id = UUID()
    }
    
    static func == (lhs: CreneauList, rhs: CreneauList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

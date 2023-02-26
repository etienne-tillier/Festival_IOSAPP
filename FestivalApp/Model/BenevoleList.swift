//
//  BenevoleList.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI

enum BenevoleListState {
    case ready
    case isLoading
    case load([Benevole])
    case remove(IndexSet)
    case updated
    case error
}

class BenevoleList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    @Published var benevoles : [Benevole]
    @Published var state : BenevoleListState = .isLoading {
        didSet{
            switch state {
            case .isLoading:
                print("loading...")
            case .load(let benevoles):
                self.benevoles = benevoles
            case .remove(let index):
                print(index)
                self.benevoles.remove(atOffsets: index)
            default:
                break
            }
        }
    }
    
    init(benevoles : [Benevole]){
        self.benevoles = benevoles
        self.id = UUID()
    }
    
    
    init(){
        self.benevoles = []
        self.id = UUID()
    }
    
    static func == (lhs: BenevoleList, rhs: BenevoleList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

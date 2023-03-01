//
//  BenevoleList.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI

enum ZoneListState {
    case ready
    case isLoading
    case load([Zone])
    case remove(IndexSet)
    case add(Zone)
    case updated
    case error
}

class ZoneList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    @Published var zones : [Zone]
    @Published var state : ZoneListState = .isLoading {
        didSet{
            switch state {
            case .load(let zones):
                self.zones = zones
            case .remove(let index):
                self.zones.remove(atOffsets: index)
            case .add(let zone):
                self.zones.append(zone)
            default:
                break
            }
        }
    }
    
    init(zones : [Zone]){
        self.zones = zones
        self.id = UUID()
    }
    
    
    init(){
        self.zones = []
        self.id = UUID()
    }
    
    static func == (lhs: ZoneList, rhs: ZoneList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

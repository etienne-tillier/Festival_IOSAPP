//
//  BenevoleList.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI

enum FestivalListState {
    case ready
    case getFestivals
    case isLoading
    case load([Festival])
    case removing
    case remove(IndexSet)
    case add(Festival)
    case updated
    case error
}
//a generaliser
class FestivalList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    @Published var festivals : [Festival]
    @Published var state : FestivalListState = .isLoading {
        didSet{
            switch state {
            case .load(let festivals):
                self.festivals = festivals
            case .remove(let index):
                self.festivals.remove(atOffsets: index)
            case .add(let festival):
                self.festivals.append(festival)
            default:
                break
            }
        }
    }
    
    init(festivals : [Festival]){
        self.festivals = festivals
        self.id = UUID()
    }
    
    
    init(){
        self.festivals = []
        self.id = UUID()
    }
    

    
    static func == (lhs: FestivalList, rhs: FestivalList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

//
//  Benevole.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI


class ErrorObject : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    @Published var message : String
    @Published var isPresented : Bool

    init(message: String) {
        self.id = UUID()
        self.message = message
        self.isPresented = false
    }
    
    init(){
        self.id = UUID()
        self.message = ""
        self.isPresented = false
    }


    
    
    func updateState() {
        objectWillChange.send()
    }
    
    static func == (lhs: ErrorObject, rhs: ErrorObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
}

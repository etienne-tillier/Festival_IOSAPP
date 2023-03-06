//
//  BenevoleListIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI


struct BenevoleListIntent {
    
    private var benevoles : BenevoleList
    private var dao : BenevoleDAO = BenevoleDAO()
    
    init(benevoles: BenevoleList) {
        self.benevoles = benevoles
    }
    
    func loadBenevoles() {
        self.benevoles.state = .isLoading
    }
    
    func remove(index : IndexSet) {
        self.benevoles.state = .remove(index)
    }
    
    func add(nom : String, prenom : String, email : String) {
        self.benevoles.state = .add(nom, prenom, email)
    }
    
}

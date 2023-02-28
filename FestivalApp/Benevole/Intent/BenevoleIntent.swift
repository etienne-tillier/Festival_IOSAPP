//
//  BenevoleIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI

struct BenevoleIntent {
    
    private var benevole : Benevole
    private var dao : BenevoleDAO = BenevoleDAO()
    
    init(benevole : Benevole){
        self.benevole = benevole
    }
    
    func loadBenevoleById(id : String) async -> Benevole? {
        
        do {
            DispatchQueue.main.async {
                benevole.state = .isLoading
            }
            
            let newBenevole : Benevole = try await dao.getBenevolebyId(id: id)!
            DispatchQueue.main.async {
                benevole.state = .load(newBenevole.id, newBenevole.nom, newBenevole.prenom, newBenevole.email)
                benevole.state = .ready
            }
            return newBenevole
        }
        catch {
            print(error)
            DispatchQueue.main.async {
                benevole.state = .error
            }
        }
        return nil
    }
    
    /*
    func updateBenevole(nom: String, prenom: String, email: String) async {
        do {
            DispatchQueue.main.async {
                benevole.state = .isLoading
            }
            
            //api
            DispatchQueue.main.async {
                benevole.state = .load(benevole.id, nom, prenom, email)
                benevole.state = .ready
            }
        }
    }
    */
    
    func removeBenevoleById(id : String) async {
        do {
            
        }
    }
    
    
    
}

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
    
    func loadBenevoles() async -> [Benevole]? {
        
        do {
            DispatchQueue.main.async {
                benevoles.state = .isLoading
            }
            
            let newBenevoles : [Benevole] = try await dao.getAllBenevole()!
            DispatchQueue.main.async {
                benevoles.state = .load(newBenevoles)
                benevoles.state = .ready
            }
            return newBenevoles
        }
        catch {
            DispatchQueue.main.async {
                benevoles.state = .error
            }
        }
        return nil
    }
    
    func remove(index : IndexSet) async {
        DispatchQueue.main.async {
            self.benevoles.state = .remove(index)
            self.benevoles.state = .ready
        }
        do {
                await dao.removeBenevoleById(id: benevoles.benevoles[index.first!].id) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        benevoles.state = .error
                    }
                case .success():
                    print("Le benevole a été supprimé avec succès !")
                }
            }
        }

    }
    
}

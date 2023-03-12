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
    
    /*
    
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
     */
    
    
    func updateBenevole(nom: String, prenom: String, email: String) async {
        do {
            
            //api
            await dao.updateBenevole(id: self.benevole.id, nom: nom, prenom: prenom, email: email) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.benevole.state = .error
                    }
                case .success():
                    DispatchQueue.main.async {
                        self.benevole.state = .update(nom, prenom, email)
                        self.benevole.state = .ready
                    }
                }
            }

        }
    }
    
    func remove() async {
        DispatchQueue.main.async {
            self.benevole.state = .removing
        }
        await dao.removeBenevoleById(id: self.benevole.id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.benevole.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.benevole.state = .removed
                }
                print("benevole removed")
            }
        }
    }
    
    
    
    
}

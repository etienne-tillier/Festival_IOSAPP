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
    
    func loadBenevoles() async {
        do {
            DispatchQueue.main.async {
                self.benevoles.state = .isLoading
            }
            let newBenevoles : [Benevole] = try await dao.getAllBenevole()!
            DispatchQueue.main.async {
                self.benevoles.state = .load(newBenevoles)
                self.benevoles.state = .ready
            }
        }
        catch {
            DispatchQueue.main.async {
                self.benevoles.state = .error
            }
        }
    }
    
    func remove(index : IndexSet) async {
        do {
            DispatchQueue.main.async {
                self.benevoles.state = .removing
            }
            await dao.removeBenevoleById(id: self.benevoles.benevoles[index.first!].id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.benevoles.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.benevoles.state = .remove(index)
                    self.benevoles.state = .ready
                    print("Le benevole a été supprimé avec succès !")
                }
            }
        }
        }
    }
    
    func add(nom : String, prenom : String, email : String) async {
        do {
            await dao.createBenevole(nom: nom, prenom: prenom, email: email) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.benevoles.state = .error
                    }
                case .success(let benevole):
                    DispatchQueue.main.async {
                        self.benevoles.state = .add(benevole)
                        self.benevoles.state = .ready
                    }
                }
                
            }
        }
    }
    
}

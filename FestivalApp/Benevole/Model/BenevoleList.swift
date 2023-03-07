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
    case add(String, String, String)
    case updated
    case error
}

class BenevoleList : Identifiable, ObservableObject, Hashable, Equatable {
    
    var id : UUID
    var dao : BenevoleDAO = BenevoleDAO()
    @Published var benevoles : [Benevole]
    @Published var state : BenevoleListState = .isLoading {
        didSet{
            switch state {
            case .isLoading:
                Task {
                    await self.loadBenevoles()
                }
            case .load(let benevoles):
                self.benevoles = benevoles
            case .remove(let index):
                Task {
                    await self.remove(index: index)
                }
            case .add(let nom, let prenom, let email):
                Task{
                    await self.add(nom: nom, prenom: prenom, email: email)
                }
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
    
    func remove(index: IndexSet) async {
        do {
            await dao.removeBenevoleById(id: self.benevoles[index.first!].id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.benevoles.remove(atOffsets: index)
                    self.state = .ready
                    print("Le benevole a été supprimé avec succès !")
                }
            }
        }
        }

    }
    
    func loadBenevoles() async {
        do {
            let newBenevoles : [Benevole] = try await dao.getAllBenevole()!
            DispatchQueue.main.async {
                self.state = .load(newBenevoles)
                self.state = .ready
            }
        }
        catch {
            DispatchQueue.main.async {
                self.state = .error
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
                        self.state = .error
                    }
                case .success(let benevole):
                    DispatchQueue.main.async {
                        self.benevoles.append(benevole)
                        self.state = .ready
                    }
                }
                
            }
        }
    }
    
    static func == (lhs: BenevoleList, rhs: BenevoleList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    
    
    
}

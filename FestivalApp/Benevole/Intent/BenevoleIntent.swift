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
    
    
    
    func loadBenevoleById(id : String) async {
        
        do {
            DispatchQueue.main.async {
                benevole.state = .isLoading
            }
            
            let newBenevole : Benevole = try await dao.getBenevolebyId(id: id)!
            DispatchQueue.main.async {
                benevole.state = .load(newBenevole)
                benevole.state = .ready
            }
        }
        catch {
            print(error)
            DispatchQueue.main.async {
                benevole.state = .error
            }
        }
    }
    
    
    
    func updateBenevole(nom: String, prenom: String, email: String) async {
        do {
            
            //api
            await dao.updateBenevole(id: self.benevole.id, nom: nom, prenom: prenom, email: email) { result in
                switch result {
                case .failure(_):
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
    
    func remove(completion: @escaping(Result<Void,Error>) -> Void) async {
        DispatchQueue.main.async {
            self.benevole.state = .removing
        }
        await dao.removeBenevoleById(id: self.benevole.id) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.benevole.state = .error
                }
                completion(.failure(error))
            case .success():
                DispatchQueue.main.async {
                    self.benevole.state = .removed
                }
                completion(.success(()))
            }
        }
    }
    
    func loadBenevoleData(benevole : Benevole){
        self.benevole.state = .load(benevole)
        self.benevole.state = .ready
    }
    
    func removeDispo(index : IndexSet) async {
        /*
        DispatchQueue.main.async {
            self.benevole.state = .removing
        }
         */
        await dao.removeDispoForBenevole(benevoleId: benevole.id, dispo: benevole.dispo[index.first!]){ result in
            switch result {
            case .failure(let error):
                print(error)
            case .success():
                DispatchQueue.main.async {
                    self.benevole.dispo.remove(atOffsets: index)
                }
                /*
                DispatchQueue.main.async {
                    self.benevole.state = .removeDispo(index)
                    self.benevole.state = .ready
                }
                 */
            }
        }
    }
    
    func addDispo(date : Date, heureDebut : Int, heureFin : Int, completion: @escaping(Result<Void,Error>) -> Void) async {
        let creneau : (Date, Date) = Tools.getStartAndEndDates(forDay: date, startHour: heureDebut, endHour: heureFin)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDateString = dateFormatter.string(from: creneau.0)
        let endDateString = dateFormatter.string(from: creneau.1)
        await dao.addCreneauForBenevole(benevoleId: benevole.id, heureDebut: startDateString, heureFin: endDateString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                DispatchQueue.main.async {
                    self.benevole.dispo.append([startDateString,endDateString])
                    completion(.success(()))
                }
            }
        }
    }
    
    func disconnectUser(){
        self.benevole.state = .disconnected
    }
    
    
    
    
}

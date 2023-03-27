//
//  BenevoleIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI

struct FestivalIntent {
    
    private var festival : Festival
    private var dao : FestivalDAO = FestivalDAO()
    
    init(festival : Festival){
        self.festival = festival
    }
    
    
    
    func getFestivalById(id : String) async {
        do {
            DispatchQueue.main.async {
                festival.state = .isLoading
            }
            
            let newFestival : Festival = try await dao.getFestivalbyId(id: id)!
            DispatchQueue.main.async {
                festival.state = .load(newFestival)
                festival.state = .ready
            }
        }
        catch {
            print(error)
            DispatchQueue.main.async {
                festival.state = .error
            }
        }
    }
    
    /*
    
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
     */
    
    func addZone(festivalId : String, nom: String, nbBenev : Int, completion: @escaping(Result<Zone,Error>) -> Void) async {
        DispatchQueue.main.async {
            self.festival.state = .isLoading
        }
        await dao.addZone(idFestival: festivalId, nom: nom, nbBenev: nbBenev){ result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.festival.state = .error
                }
                completion(.failure(error))
            case .success(let zone):
                DispatchQueue.main.async {
                    self.festival.state = .addZone(zone)
                    self.festival.state = .ready
                }
                completion(.success((zone)))
            }
        }
    }
    
    
    
    
}

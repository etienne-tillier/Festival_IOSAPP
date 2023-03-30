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
            DispatchQueue.main.async {
                festival.state = .error
            }
        }
    }
    
  
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

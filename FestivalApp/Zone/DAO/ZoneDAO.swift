//
//  ZoneDAO.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

class ZoneDAO {
    
    
    func getAllZones(completion: @escaping(Result<[Zone],Error>) -> Void) async {
        
        guard let url = URL(string: Env.get("API_URL") + "zones") else {
            completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "zones")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
        guard let zones : [Zone] = try? await URLSession.shared.getJSON(from: request) else {
            completion(.failure(MyError.apiProblem(message: "Impossible d'obtenir les zones de l'API")))
            return
        }
        
        completion(.success((zones)))
            
    }
    

}

//
//  ZoneDAO.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 01/03/2023.
//

import Foundation
import SwiftUI

class ZoneDAO {
    
    func getZoneById(id: String, completion: @escaping(Result<Zone,Error>) -> Void) async {
        
        guard let url = URL(string: Env.get("API_URL") + "zones/" + id) else {
            completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "zones/" + id )))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
        guard let zone : Zone = try? await URLSession.shared.getJSON(from: request) else {
            completion(.failure(MyError.apiProblem(message: "Impossible to get the zone")))
            return
        }
        for creneau in zone.creneaux{
            creneau.setZone(zone: zone)
        }
        completion(.success(zone))
        
    
    }
    
    
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
        
        for zone in zones{
            for creneau in zone.creneaux{
                creneau.setZone(zone: zone)
            }
        }
        
        
        completion(.success((zones)))
            
    }
    
    func removeCreneauFromZone(zoneId : String, creneau: Creneau, completion: @escaping(Result<Void,Error>) -> Void) async {
        
        do{
            guard let url = URL(string: Env.get("API_URL") + "zones/removeBenevFrom/" + zoneId) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "zones/removeBenevFrom/" + zoneId )))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let creneauData = ["id": creneau.benevole.id, "heureDebut": creneau.dateDebut]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: creneauData) else {
                completion(.failure(MyError.convertion()))
                return
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                        let error = NSError(domain: Env.get("API_URL"), code: 1, userInfo: [NSLocalizedDescriptionKey: "Erreur de serveur"])
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(()))
                }.resume()
        }
        
    }
    
    func addCreneauToZone(zoneId: String, benevoleId: String, dateDebut: String, dateFin: String, completion: @escaping(Result<Void,Error>) -> Void) async {
        do {
            guard let url = URL(string: Env.get("API_URL") + "zones/addBenevoleTo/" + zoneId) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "zones/addBenevoleTo/" + zoneId )))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")

            let creneauData = [
                "benevole": benevoleId,
                "heureDebut": dateDebut,
                "heureFin" : dateFin
            ] as [String : String]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: creneauData) else {
                completion(.failure(MyError.convertion()))
                return
            }

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    let error = NSError(domain: Env.get("API_URL"), code: 1, userInfo: [NSLocalizedDescriptionKey: "Erreur de serveur"])
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    }
    
    func getCreneauByBenevole(benevoleId: String, completion: @escaping(Result<[Creneau],Error>) -> Void) async {
        guard let url = URL(string: Env.get("API_URL") + "benevoles/" + benevoleId + "/zones") else {
            completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles" + benevoleId + "/zones")))
            return
        }
        
        //la barre de rech disparait
        //on peut plus ajouter de creneaux
        //on peut pas fetch les creneaux dans les benev
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
        
        guard let creneaux : [Creneau] = try? await URLSession.shared.getJSON(from: request) else {
            completion(.failure(MyError.apiProblem(message: "Impossible to get creneau for this benevole")))
            return
        }

        completion(.success(creneaux))
        }



    
}

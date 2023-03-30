//
//  FestivalDAO.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI


class FestivalDAO {
    
    private var zoneDao : ZoneDAO = ZoneDAO()
    
    
    func getAllFestivals() async throws -> [Festival]? {
        do {
            guard let url = URL(string: Env.get("API_URL") + "festivals") else {
                throw MyError.invalidURL(message: Env.get("API_URL") + "festivals/")
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let festivals : [Festival] = try await URLSession.shared.getJSON(from: request)
            return festivals
        }
        catch {
            throw error
        }
    }
    
    func getFestivalbyId(id : String) async throws -> Festival? {
        do{
            guard let url = URL(string: Env.get("API_URL") + "festivals/" + id) else {
                throw MyError.invalidURL(message: Env.get("API_URL") + "festivals/" + id )
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let festival : Festival = try await URLSession.shared.getJSON(from: request)
            return festival
        }
        catch{
            throw MyError.apiProblem(message: "Impossible to get the festival")
        }
    }
    
    func removeFestivalById(id : String, completion: @escaping (Result<Void, Error>) -> Void) async {
        do{
            guard let url = URL(string: Env.get("API_URL") + "festivals/" + id) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "festivals/" + id )))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
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
    
    func updateFestival(id : String, nom : String, completion: @escaping (Result<Void, Error>) -> Void) async  {
        
        do {
            guard let url = URL(string: Env.get("API_URL") + "festivals/setName/" + id) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "festivals/setName/" + id)))
                return
            }
            
            let festivalData = ["nom": nom]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: festivalData) else {
                completion(.failure(MyError.convertion()))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
                else {
                    let error = NSError(domain: Env.get("API_URL"), code: 1, userInfo: [NSLocalizedDescriptionKey : "Erreur de serveur"])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(()))
                
            }.resume()
        }
        
    }
    
    func createFestival(nom : String, dateDebut: String, nbJours: Int, completion : @escaping (Result<Festival,Error>) -> Void) async {
        do {
            guard let url = URL(string: Env.get("API_URL") + "festivals") else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "festivals")))
                return
            }
            
            let festivalData : [String: Any] = ["nom": nom, "dateDebut": dateDebut, "nbJours": nbJours]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: festivalData) else {
                completion(.failure(MyError.convertion()))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            guard let newFestival : Festival = try? await URLSession.shared.getJSON(from: request) else {
                completion(.failure(MyError.apiProblem(message: "Impossible de créer le festival")))
                return
            }
            completion(.success(newFestival))
        }
        
    }
    
    func addZone(idFestival : String, nom : String, nbBenev : Int, completion : @escaping(Result<Zone,Error>) -> Void) async {
        await zoneDao.createZone(nom: nom, nombreBenevole: nbBenev) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let zone):
                do {
                    guard let url = URL(string: Env.get("API_URL") + "festivals/addZone/" + idFestival) else {
                        completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "festivals/addZone/" + idFestival)))
                        return
                    }
                    
                    let festivalData = ["zoneId": zone.id]
                    
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: festivalData) else {
                        completion(.failure(MyError.convertion()))
                        return
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "PATCH"
                    request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
                        else {
                            let error = NSError(domain: Env.get("API_URL"), code: 1, userInfo: [NSLocalizedDescriptionKey : "Erreur de serveur"])
                            completion(.failure(error))
                            return
                        }
                        
                        completion(.success((zone)))
                        
                    }.resume()
                }
                
            }
        }
    }
        
}


    
    
    
    
    


//
//  BenevoleDAO.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI


class BenevoleDAO {
    
    
    func getAllBenevole() async throws -> [Benevole]? {
        do {
            guard let url = URL(string: Env.get("API_URL") + "benevoles") else {
                throw MyError.invalidURL(message: Env.get("API_URL") + "benevoles/")
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let benevoles : [Benevole] = try await URLSession.shared.getJSON(from: request)
            return benevoles
        }
        catch {
            throw MyError.apiProblem(message: "Impossible to get all the benevoles")
        }
    }
    
    func getBenevolebyId(id : String) async throws -> Benevole? {
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + id) else {
                throw MyError.invalidURL(message: Env.get("API_URL") + "benevoles/" + id )
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let benevole : Benevole = try await URLSession.shared.getJSON(from: request)
            return benevole
        }
        catch{
            throw MyError.apiProblem(message: "Impossible to get the benevole")
        }
    }
    
    func removeBenevoleById(id : String, completion: @escaping (Result<Void, Error>) -> Void) async {
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + id) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles/" + id )))
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
    
    func updateBenevole(id : String, nom : String, prenom : String, email : String, completion: @escaping (Result<Void, Error>) -> Void) async  {
        
        do {
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + id) else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles/" + id)))
                return
            }
            
            let benevoleData = ["nom": nom, "prenom": prenom, "email": email]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: benevoleData) else {
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
                
                completion(.success(()))
                
            }.resume()
        }
        
    }
    
    func createBenevole(nom : String, prenom : String, email : String, completion : @escaping (Result<Benevole,Error>) -> Void) async {
        do {
            guard let url = URL(string: Env.get("API_URL") + "benevoles") else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles")))
                return
            }
            
            let benevoleData = ["nom": nom, "prenom": prenom, "email": email]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: benevoleData) else {
                completion(.failure(MyError.convertion()))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            guard let newBenevole : Benevole = try? await URLSession.shared.getJSON(from: request) else {
                completion(.failure(MyError.apiProblem(message: "Impossible de créer le benevole")))
                return
            }
            completion(.success(newBenevole))
        }
        
    }
    
    func getBenevoleAvailableForCreneau(startDate : String, endDate : String, completion: @escaping(Result<[Benevole],Error>) -> Void) async {
        do {
            guard let url = URL(string: Env.get("API_URL") + "zones/availableBenevoles/") else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "zones/availableBenevoles/")))
                return
            }
            
            let bodyData = ["heureDebut": startDate, "heureFin": endDate]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else {
                completion(.failure(MyError.convertion()))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            guard let benevoleAvailable : [Benevole] = try? await URLSession.shared.getJSON(from: request) else {
                completion(.failure(MyError.apiProblem(message: "Impossible d'avoir les bénévoles disponibles pour ce créneau")))
                return
            }
                
                completion(.success((benevoleAvailable)))
            }
        }
    
    func removeDispoForBenevole(benevoleId : String, dispo: [String], completion: @escaping(Result<Void,Error>) -> Void) async {
        
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + benevoleId + "/removeSlot") else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles/" + benevoleId + "/removeSlot")))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let dispoData = ["heureDebut": dispo[0]]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dispoData) else {
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
    
    func addCreneauForBenevole(benevoleId : String, heureDebut : String, heureFin : String, completion: @escaping(Result<Void,Error>) -> Void) async {
        
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + benevoleId + "/addSlot") else {
                completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles/" + benevoleId + "/addSlot")))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
            let dispoData = ["heureDebut": heureDebut, "heureFin": heureFin]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dispoData) else {
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
        
    }


    
    
    
    
    


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
                throw MyError.invalidURL(url: Env.get("API_URL") + "benevoles/")
            }
            let benevoles : [Benevole] = try await URLSession.shared.getJSON(from: url)
            return benevoles
        }
        catch {
            throw MyError.apiProblem(message: "Impossible to get all the benevoles")
        }
    }
    
    func getBenevolebyId(id : String) async throws -> Benevole? {
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + id) else {
                throw MyError.invalidURL(url: Env.get("API_URL") + "benevoles/" + id )
            }
            let benevole : Benevole = try await URLSession.shared.getJSON(from: url)
            return benevole
        }
        catch{
            throw MyError.apiProblem(message: "Impossible to get the benevole")
        }
    }
    
    func removeBenevoleById(id : String, completion: @escaping (Result<Void, Error>) -> Void) async throws {
        do{
            guard let url = URL(string: Env.get("API_URL") + "benevoles/" + id) else {
                completion(.failure(MyError.invalidURL(url: Env.get("API_URL") + "benevoles/" + id )))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
                
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

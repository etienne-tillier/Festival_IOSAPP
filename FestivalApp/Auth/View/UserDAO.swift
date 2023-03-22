//
//  UserDAO.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/03/2023.
//

import Foundation
import SwiftUI

class UserDAO {
    
    func getLoggedBenevole(uid : String, completion: @escaping(Result<Benevole,Error>) -> Void ) async {
        guard let url = URL(string: Env.get("API_URL") + "benevoles/byUID/"  + uid) else {
            completion(.failure(MyError.invalidURL(message: Env.get("API_URL") + "benevoles/byUID/" + uid)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + TokenManager.shared.getToken()!, forHTTPHeaderField: "Authorization")
        
        guard let user : Benevole = try? await URLSession.shared.getJSON(from: request) else {
            print("j'ai pas le user")
            completion(.failure(MyError.apiProblem(message: "Impossible to get datas for this user")))
            return
        }
        print("j'ai le user")
        completion(.success(user))
    }
    
}

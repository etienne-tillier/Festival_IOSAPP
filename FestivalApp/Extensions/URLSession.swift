//
//  URLSession.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import Foundation
import SwiftUI

extension URLSession {
    func getJSON<T: Decodable>(
        from request: URLRequest) async throws -> T {
            let (data, _) = try await data(for: request)
            
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
             
            let decoder = JSONDecoder() // création d'un décodeur
            let decoded = try decoder.decode(T.self, from: data)
            print(decoded)
            return decoded
        }
}

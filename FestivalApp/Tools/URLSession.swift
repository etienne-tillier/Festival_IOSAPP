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
        from url: URL) async throws -> T {
            let (data, _) = try await data(from: url)
            let decoder = JSONDecoder() // création d'un décodeur
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        }
}

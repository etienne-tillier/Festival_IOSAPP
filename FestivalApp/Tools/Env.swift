//
//  Env.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import Foundation

final class Env {
    
    static func get(_ key: String) -> String {
            guard let value = ProcessInfo.processInfo.environment[key] else {
                fatalError("Unable to find value for key \(key) in environment")
            }
            return value
        }
}

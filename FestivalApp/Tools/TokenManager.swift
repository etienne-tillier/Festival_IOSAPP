//
//  TokenManager.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 28/02/2023.
//

import Foundation

class TokenManager {
    
    static let shared : TokenManager = TokenManager()
    
    private var token: String?
    
    func setToken(token: String) {
        self.token = token
    }
    
    func getToken() -> String? {
        return self.token
    }
    
    func hasToken() -> Bool {
        return self.token != nil
    }
}

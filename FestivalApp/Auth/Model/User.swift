//
//  User.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 28/02/2023.
//

import Foundation
import SwiftUI

class UserSettings : ObservableObject {
    
    @Published var user : User?
    
    init(user: User? = nil) {
        self.user = user
    }
    
}

struct User {
    
    var email : String
    var uid : String
    
}

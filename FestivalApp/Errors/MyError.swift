//
//  MyErrors.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import Foundation
import SwiftUI

enum MyError : Error {
    case invalidURL(message : String = "Problème d'url")
    case apiProblem(message: String = "Prolème d'API")
    case convertion(message: String = "Problème de convertion")
}

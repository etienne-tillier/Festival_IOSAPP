//
//  MyErrors.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 26/02/2023.
//

import Foundation
import SwiftUI

enum MyError : Error {
    case invalidURL(url : String)
    case apiProblem(message: String)
}

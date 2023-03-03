//
//  String.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import Foundation

extension String{
    
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }

    func convertToDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getHour() -> Int? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: self) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                return hour
            }
            return nil
        }
    
}

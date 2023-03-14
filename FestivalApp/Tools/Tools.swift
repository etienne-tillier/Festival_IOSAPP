//
//  Tools.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 14/03/2023.
//

import Foundation


class Tools {
    static func getStartAndEndDates(forDay day: Date, startHour: Int, endHour: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current

        // Extract the year, month, and day components from the given day date
        //let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)

        // Create date components for the start hour
        var startComponents = DateComponents()
        startComponents.hour = startHour
        startComponents.minute = 0

        // Create date components for the end hour
        var endComponents = DateComponents()
        endComponents.hour = endHour
        endComponents.minute = 0

        // Combine the day components with the start/end hour components to create the start/end dates
        if let startDate = calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: day),
           let endDate = calendar.date(bySettingHour: endHour, minute: 0, second: 0, of: day) {
            return (startDate, endDate)
        } else {
            return nil
        }
    }
}

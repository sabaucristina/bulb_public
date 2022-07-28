//
//  Calendar+numberOfDays.swift
//  Bulb
//
//  Created by Sabau Cristina on 01/07/2022.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)

        return numberOfDays.day!
    }
}

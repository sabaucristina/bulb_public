//
//  Date+addingDays.swift
//  Bulb
//
//  Created by Sabau Cristina on 18/07/2022.
//

import Foundation

extension Date {
     func adding(days: Int) -> Date {
         return Calendar.current.date(byAdding: .day, value: days, to: self)!
     }
 }

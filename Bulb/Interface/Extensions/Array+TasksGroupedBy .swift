//
//  Array+TasksGroupedBy .swift
//  Bulb
//
//  Created by Sabau Cristina on 10/06/2022.
//

import Foundation

extension Array where Element == Task {
    func groupBySite() -> [String: [Task]] {
        Dictionary(grouping: self, by: { $0.site })
    }

    func groupByDeadline() -> [Date: [Task]] {
        Dictionary(
            grouping: self,
            by: { $0.deadline }
        )
    }
}

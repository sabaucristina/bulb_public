//
//  HomeScreenSectionProtocol.swift
//  Bulb
//
//  Created by Sabau Cristina on 05/07/2022.
//

import Foundation
import UIKit

protocol HomeScreenSectionProtocol: AnyObject {
    var numberOfItems: Int { get }
    func cellModel(for index: Int) -> TableViewItemModel
    func onTap(index: Int)
    var headerModel: SimpleHeaderView.Model? { get }
}

extension HomeScreenSectionProtocol {
    func onTap(index: Int) {}
}

enum HomeSectionAction {
    case showTaskDetails(Task)
    case showSnoozeModal(Task)
    case completeTask(Task)
}

enum TableViewItemModel: Equatable {
    case task(TaskCellView.Model)
    case banner(SimpleBannerCell.Model)
    case tasksCompleted(SimpleBannerCell.Model)
}

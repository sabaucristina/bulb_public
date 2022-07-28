//
//  BannerSection.swift
//  Bulb
//
//  Created by Sabau Cristina on 05/07/2022.
//

import Foundation

final class BannerSection: HomeScreenSectionProtocol {
    var numberOfItems: Int { 1 }

    func cellModel(for index: Int) -> TableViewItemModel {
        .banner(
            .init(
                title: "You don't have any tasks",
                icon: Image.clock
            )
        )
    }

    var headerModel: SimpleHeaderView.Model?
}

//
//  UIView+Constraints.swift
//  Bulb
//
//  Created by Sabau Cristina on 07/06/2022.
//

import Foundation
import UIKit

extension UIView {
    enum ViewEdge: Hashable {
        case left(CGFloat)
        case right(CGFloat)
        case bottom(CGFloat)
        case top(CGFloat)
    }
    func pinToSuperviewEdges(edges: Set<ViewEdge> = [.top(0), .bottom(0), .left(0), .right(0)]) {
        guard let superview = self.superview else { return assertionFailure() }
        edges.forEach { edge in
            switch edge {
            case .left(let constant):
                pinToLeftEdge(of: superview, with: constant)
            case .right(let constant):
                pinToRightEdge(of: superview, with: constant)
            case .top(let constant):
                pinToTopEdge(of: superview, with: constant)
            case .bottom(let constant):
                pinToBottomEdge(of: superview, with: constant)
            }
        }
    }
    func pinToHorizontalEdges(of view: UIView, with const: CGFloat = 0) {
        pinToLeftEdge(of: view, with: const)
        pinToRightEdge(of: view, with: const)
    }
    func pinToVerticalEdges(of view: UIView, with const: CGFloat = 0) {
        pinToTopEdge(of: view, with: const)
        pinToBottomEdge(of: view, with: const)
    }
    func pinToTopEdge(of view: UIView, with const: CGFloat = 0) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: const).isActive = true
    }
    func pinToBottomEdge(of view: UIView, with const: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: const).isActive = true
    }
    func pinToLeftEdge(of view: UIView, with const: CGFloat = 0) {
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: const).isActive = true
    }
    func pinToRightEdge(of view: UIView, with const: CGFloat = 0) {
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: const).isActive = true
    }
}

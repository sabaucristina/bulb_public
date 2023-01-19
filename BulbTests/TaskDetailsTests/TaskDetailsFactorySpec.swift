//
//  TaskDetailsFactorySpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 19/08/2022.
//

import Quick
import Nimble
@testable import Bulb

final class TaskDetailsFactorySpec: QuickSpec {
    override func spec() {
        var sut: TaskDetailsFactory!
        var task: Task!
        var routerMock: RouterMock!

        beforeEach {
            sut = TaskDetailsFactory()
            task = .stub()
            routerMock = RouterMock()
        }

        describe("Making") {
            context("add task details controlller") {
                it("should create ViewController") {
                    let controller = sut.makeTaskAddDetailsController(task: task)
                    expect(controller).to(beAKindOf(TaskAddDetailsViewController.self))
                }
            }

            context("actions modal") {
                it("should show UIAlertController") {
                    let controller = sut.makeActionsModal(isPerformed: true, task: task, router: routerMock) { _ in }
                    expect(controller).to(beAKindOf(UIAlertController.self))
                }
            }
        }
    }
}

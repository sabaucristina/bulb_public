//
//  HomeScreenFactorySpecs.swift
//  BulbTests
//
//  Created by Sabau Cristina on 16/08/2022.
//

import Quick
import Nimble
@testable import Bulb

final class HomeScreenFactorySpec: QuickSpec {
    override func spec() {
        var sut: HomeScreenFactory!
        var task: Task!

        beforeEach {
            sut = HomeScreenFactory()
            task = .stub()
        }

        describe("Making") {
            context("task details screen") {
                it("should create a TaskDetailsViewController") {
                    //given
                    let taskCategory: TaskCategory = .today

                    //when
                    let controller = sut.makeTaskDetailsScreen(task: task, taskCategory: taskCategory) { _ in }

                    //then
                    expect(controller).to(beAKindOf(TaskDetailsViewController.self))
                }
            }

            context("snooze modal") {
                it("should show a UIAlertController") {
                    let controller = sut.makeSnoozeModal(task: task) { _ in }
                    expect(controller).to(beAKindOf(UIAlertController.self))
                }
            }
        }
    }
}

//
//  TaskDetailsViewModelSpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 19/08/2022.
//

import Quick
import Nimble
@testable import Bulb

final class TaskDetailsViewModelSpec: QuickSpec {

    override func spec() {
        var sut: TaskDetailsViewModel!
        var routerMock: RouterMock!
        var screenFactoryMock: TaskDetailsFactoryMock!
        var task: Task!
        var latestOnAction: TaskDetailsViewModel.Action?
        var taskCategory: TaskCategory!

        beforeEach {
            routerMock = RouterMock()
            screenFactoryMock = TaskDetailsFactoryMock()
            task = .stub()
            taskCategory = .today
            sut = TaskDetailsViewModel(
                task: task,
                taskCategory: taskCategory,
                onAction: { latestOnAction = $0 },
                router: routerMock,
                screenFactory: screenFactoryMock
            )
        }

        describe("show todays's task details") {
            context("when reload data") {
                beforeEach {
                    taskCategory = .today
                    sut = TaskDetailsViewModel(
                        task: task,
                        taskCategory: taskCategory,
                        onAction: { _ in },
                        router: routerMock,
                        screenFactory: screenFactoryMock
                    )
                    sut.reloadData()
                }
                it("has 2 sections") {
                    expect(sut.numberOfSections()) == 2
                }

                it("has first section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 0)) == 1
                }

                it("has second section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 1)) == 1
                }

                it("has expected header title") {
                    let expectedFirstSectionTitle = "Plant Name - " + task.taskType
                    let expectedSecondSectionTitle = task.taskType + " Instructions"
                    expect(sut.sectionTitle(section: 0)).to(equal(expectedFirstSectionTitle))
                    expect(sut.sectionTitle(section: 1)).to(equal(expectedSecondSectionTitle))
                }
            }
        }
        describe("show upcoming task details") {
            context("when reload data") {
                beforeEach {
                    taskCategory = .upcoming
                    sut = TaskDetailsViewModel(
                        task: task,
                        taskCategory: taskCategory,
                        onAction: { _ in },
                        router: routerMock,
                        screenFactory: screenFactoryMock
                    )
                    sut.reloadData()
                }
                it("has 2 sections") {
                    expect(sut.numberOfSections()) == 2
                }

                it("has first section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 0)) == 1
                }

                it("has second section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 1)) == 1
                }

                it("has expected header title") {
                    let expectedFirstSectionTitle = "Plant Name - " + task.taskType
                    let expectedSecondSectionTitle = task.taskType + " Instructions"
                    expect(sut.sectionTitle(section: 0)).to(equal(expectedFirstSectionTitle))
                    expect(sut.sectionTitle(section: 1)).to(equal(expectedSecondSectionTitle))
                }
            }
        }
        describe("show today's completed task details") {
            context("when reload data") {
                beforeEach {
                    taskCategory = .upcoming
                    task = .stub(completed: true)
                    print("tasssk\(task.completed)")
                    sut = TaskDetailsViewModel(
                        task: task,
                        taskCategory: taskCategory,
                        onAction: { _ in },
                        router: routerMock,
                        screenFactory: screenFactoryMock
                    )
                    sut.reloadData()
                }
                it("has 2 sections") {
                    expect(sut.numberOfSections()) == 2
                }

                it("has first section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 0)) == 1
                }

                it("has second section with 1 row") {
                    expect(sut.numberOfRowsInSection(section: 1)) == 1
                }

                it("has expected header title") {
                    let expectedFirstSectionTitle = "Plant Name - " + task.taskType
                    let expectedSecondSectionTitle = task.taskType + " Instructions"
                    expect(sut.sectionTitle(section: 0)).to(equal(expectedFirstSectionTitle))
                    expect(sut.sectionTitle(section: 1)).to(equal(expectedSecondSectionTitle))
                }
            }
        }
        describe("show actions modal") {
            context("when cell model on action snooze") {
                it("has expected TaskUpdateRequest and presents ViewControlller") {
                    sut.reloadData()
                    let controller = UIViewController()
                    var onPerformActionMock: ((TaskUpdateRequest) -> Void)?
                    screenFactoryMock.makeActionsModalStub = { _, _, _, onAction in
                        onPerformActionMock = onAction
                        return controller
                    }

                    var presentedScreen: UIViewController?
                    routerMock.presentModalStub = { screen in
                        presentedScreen = screen
                    }

                    //when
                    switch sut.cellModel(indexPath: .init(item: 0, section: 0)) {
                    case let .actions(model):
                        model.onTapMoreActions?()
                    default:
                        fail()
                    }

                    var dismissCalled = false
                    routerMock.dismissModalStub = { dismissCalled = true }

                    let taskStub = TaskUpdateRequest.stub()
                    onPerformActionMock?(taskStub)

                    expect(presentedScreen) === controller
                    expect(latestOnAction) == .requestUpdate(taskStub)
                    expect(dismissCalled) == true
                }
            }
        }
        describe("show task add details screen") {
            context("when tap edit button") {
                beforeEach {
                    taskCategory = .today
                    task = .stub(completed: true)
                    sut = TaskDetailsViewModel(
                        task: task,
                        taskCategory: taskCategory,
                        onAction: { _ in },
                        router: routerMock,
                        screenFactory: screenFactoryMock
                    )
                    sut.reloadData()
                }
                it("shows view controller") {
                    let controller = UIViewController()
                    screenFactoryMock.makeTaskAddDetailsControllerStub = { task in
                        return controller
                    }

                    var presentedController: UIViewController?
                    routerMock.presentModalWithOptionsStub = { screen, _, _ in
                        presentedController = screen
                    }
                    switch sut.cellModel(indexPath: .init(item: 0, section: 0)) {
                    case let .actions(model):
                        model.onTap()
                    default:
                        fail()
                    }
                    expect(presentedController === controller).to(beTrue())
                }
            }
        }
    }
}

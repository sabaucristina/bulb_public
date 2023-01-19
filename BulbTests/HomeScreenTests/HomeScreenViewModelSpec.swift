//
//  HomeScreenViewModelSpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 17/08/2022.
//

import Quick
import Nimble
@testable import Bulb

final class HomeScreenViewModelSpec: QuickSpec {
    override func spec() {
        var routerMock: RouterMock!
        var screenFactoryMock: HomeScreenFactoryMock!
        var taskServiceMock: TaskServiceMock!
        var firebaseAuthServiceMock: FirebaseAuthServiceMock!
        var sut: HomeScreenViewModel!
        var tasks: [Task]!
        var taskUpdateRequest: TaskUpdateRequest!
        var task: Task!

        beforeEach {
            routerMock = RouterMock()
            screenFactoryMock = HomeScreenFactoryMock()
            taskServiceMock = TaskServiceMock()
            firebaseAuthServiceMock = FirebaseAuthServiceMock()
            tasks = Array.init(repeating: .stub(), count: 3)
            taskUpdateRequest = .stub()
            task = .stub()
            sut = HomeScreenViewModel(
                router: routerMock,
                screenFactory: screenFactoryMock,
                taskService: taskServiceMock,
                firebaseAuthService: firebaseAuthServiceMock
            )
        }

        func setupWhenGetTodaysSucceedsWithOneCategory() {
            //given
            taskServiceMock.getTodaysTasksStub = { completion in
                completion(.success(tasks))
            }
            sut.taskCategory = .today
            //when
            sut.refreshTasks()
        }

        func setupWhenGetUpcomingTasksSucceedsWithOneCategory() {
            //given
            taskServiceMock.getUpcomingTasksStub = { completion in
                completion(.success(tasks))
            }
            sut.taskCategory = .upcoming

            //when
            sut.refreshTasks()
        }

        describe("today's tasks category") {
            context("when get today's tasks fails") {
                it("should have 0 sections") {
                    //given
                    taskServiceMock.getTodaysTasksStub = { completion in
                        let error = NSError()
                        completion(.failure(error))
                    }
                    sut.taskCategory = .today
                    //when
                    sut.refreshTasks()
                    //then
                    expect(sut.numberOfSections()) == 0
                }
            }

            context("when get today's tasks succeeds with one category") {
                it("should have 1 section") {
                    setupWhenGetTodaysSucceedsWithOneCategory()
                    expect(sut.numberOfSections()) == 1
                }
                it("should have 3 rows") {
                    setupWhenGetTodaysSucceedsWithOneCategory()
                    expect(sut.numberOfRowsInSection(section: 0)) == 3
                }
                it("should have expected header model") {
                    setupWhenGetTodaysSucceedsWithOneCategory()
                    let expectedHeaderModel = SimpleHeaderView.Model(
                        title: "bedroom",
                        fontSize: 18
                    )
                    expect(sut.headerModel(section: 0)).to(equal(expectedHeaderModel))
                }
            }
        }
        describe("upcoming tasks category") {
            context("when get upcoming tasks fails") {
                it("should have 0 sections") {
                    taskServiceMock.getUpcomingTasksStub = { completion in
                        let error = NSError()
                        completion(.failure(error))
                    }
                    sut.taskCategory = .upcoming
                    //when
                    sut.refreshTasks()
                    //then
                    expect(sut.numberOfSections()) == 0
                }

            }

            context("when get upcoming tasks succeeds with one category") {
                it("should have 1 section") {
                    setupWhenGetUpcomingTasksSucceedsWithOneCategory()
                    expect(sut.numberOfSections()) == 1
                }

                it("should have 3 rows") {
                    setupWhenGetUpcomingTasksSucceedsWithOneCategory()
                    expect(sut.numberOfRowsInSection(section: 0)) == 3
                }
                it("should expected header model") {
                    setupWhenGetUpcomingTasksSucceedsWithOneCategory()
                    let headerTitle = DateFormatter.mediumDateformatter.string(from: Date.now)
                    //then
                    let expectedHeaderModel = SimpleHeaderView.Model(
                        title: headerTitle,
                        fontSize: 18
                    )
                    expect(sut.headerModel(section: 0)).to(equal(expectedHeaderModel))
                }
            }
        }
        describe("perform task request") {
            context("when succeeds") {
                it("reloads upcoming tasks") {
                    //given
                    taskServiceMock.performTaskStub = { updateType, task, newTask, completion in
                        completion(.success("Success"))
                    }
                    taskServiceMock.getUpcomingTasksStub = { completion in
                        completion(.success([task]))
                    }
                    var didReload = false
                    sut.onAction = { didReload = $0 == .reload }
                    sut.taskCategory = .upcoming
                    //when
                    sut.performTask(requestData: taskUpdateRequest)
                    //then
                    XCTAssert(didReload)
                }
            }

            context("when fails") {
                it("has on action handle error") {
                    //given
                    let error = TestError()
                    var action: HomeScreenViewModel.Action?
                    sut.onAction = { incomingAction in
                        action = incomingAction
                    }
                    taskServiceMock.performTaskStub = { updateType, task, newTask, completion in
                        let error = TestError()
                        completion(.failure(error))
                    }

                    //when
                    sut.performTask(requestData: taskUpdateRequest)
                    //then
                    expect(action).to(equal(.handleError(error as NSError)))
                }
            }
        }
        describe("refresh tasks") {
            it("executes correctly") {
                //given
                var action: HomeScreenViewModel.Action?
                sut.onAction = { action = $0 }
                taskServiceMock.getTodaysTasksStub = { completion in
                    completion(.success(tasks))

                }
                sut.taskCategory = .today
                //when
                sut.refreshTasks()
                //then
                expect(action).to(equal(.reload))
            }
            context("when tasks is an empty array") {
                it("returns banner section") {
                    //given
                    taskServiceMock.getTodaysTasksStub = { completion in
                        completion(.success([]))

                    }
                    sut.taskCategory = .today
                    let banner = SimpleBannerCell.Model(
                        title: "You don't have any tasks",
                        icon: Image.clock
                    )
                    //when
                    sut.refreshTasks()
                    //then
                    let sutBanner = sut.cellModel(at: IndexPath(row: 0, section: 0))

                    expect(sut.numberOfSections()) == 1
                    expect(sut.numberOfRowsInSection(section: 0)) == 1
                    expect(sut.headerModel(section: 0)).to(beNil())
                    expect(sutBanner).to(equal(.banner(banner)))
                }
            }
            context("when tasks is not an empty array") {
                context("when section is today") {
                    context("when all tasks are completed") {
                        it("returns tasks completed section first") {
                            //given
                            tasks = Array.init(repeating: .stub(completed: true), count: 3)
                            taskServiceMock.getTodaysTasksStub = { completion in
                                completion(.success(tasks))

                            }
                            let tasksCompletedBanner = SimpleBannerCell.Model(
                                title: "All tasks are completed",
                                icon: Image.checkmarkCircle
                            )
                            sut.taskCategory = .today
                            //when
                            sut.refreshTasks()
                            //then
                            let sutCompletedBanner = sut.cellModel(at: IndexPath(row: 0, section: 0))
                            expect(sut.headerModel(section: 0)).to(beNil())
                            expect(sutCompletedBanner).to(equal(.tasksCompleted(tasksCompletedBanner)))
                        }
                        it("returns site tasks sections later") {

                            //given
                            tasks = Array.init(repeating: .stub(completed: true), count: 3)
                            taskServiceMock.getTodaysTasksStub = { completion in
                                completion(.success(tasks))

                            }
                            let expectedTaskCells: [TableViewItemModel] = tasks.map { task in
                                    .task(
                                        TaskCellView.Model(
                                            plantName: "Calathea",
                                            isCompleted: task.completed,
                                            isSnoozed: task.snoozed,
                                            isSkipped: task.skipped,
                                            taskType: task.taskType,
                                            isUpcomingTask: false
                                        )
                                    )
                            }
                            sut.taskCategory = .today
                            //when
                            sut.refreshTasks()
                            //then
                            let taskCells = (0..<sut.numberOfRowsInSection(section: 1)).map {
                                sut.cellModel(at: IndexPath(row: $0, section: 1))
                            }
                            expect(sut.headerModel(section: 1)).toNot(beNil())
                            expect(taskCells).to(equal(expectedTaskCells))
                        }
                    }
                }

                context("when section is upcoming") {
                    it("returns deadline sections") {
                        //given
                        taskServiceMock.getUpcomingTasksStub = { completion in
                            completion(.success(tasks))

                        }
                        let expectedTaskCells: [TableViewItemModel] = tasks.map { task in
                                .task(
                                    TaskCellView.Model(
                                        plantName: "Calathea",
                                        isCompleted: task.completed,
                                        isSnoozed: task.snoozed,
                                        isSkipped: task.skipped,
                                        taskType: task.taskType,
                                        isUpcomingTask: true
                                    )
                                )
                        }
                        sut.taskCategory = .upcoming
                        //when
                        sut.refreshTasks()
                        //then
                        let taskCells = (0..<sut.numberOfRowsInSection(section: 0)).map {
                            sut.cellModel(at: IndexPath(row: $0, section: 0))
                        }
                        expect(taskCells).to(equal(expectedTaskCells))
                    }
                }
            }
        }
        describe("show task details") {
            context("when on tap cell") {
                it("shows view controller") {
                    //given
                    setupWhenGetTodaysSucceedsWithOneCategory()

                    let controller = UIViewController()
                    var onActionMock: ((TaskDetailsViewModel.Action) -> Void)?
                    screenFactoryMock.makeTaskDetailsScreenStub = { _, _, onAction in
                        onActionMock = onAction
                        return controller
                    }

                    var presentedScreen: UIViewController?
                    routerMock.presentModalWithOptionsStub = { screen, _, _ in
                        presentedScreen = screen
                    }

                    var updateAction: TaskUpdateAction?
                    var taskUpdate: Task?
                    taskServiceMock.performTaskStub = { updateType, task, taskCreateDto, completion in
                        updateAction = updateType
                        taskUpdate = task
                    }

                    //when
                    sut.onTapCell(at: IndexPath(row: 0, section: 0))
                    let expectedTaskUpdate: TaskUpdateRequest = .stub()
                    onActionMock?(.requestUpdate(expectedTaskUpdate))

                    //then
                    expect(updateAction).to(equal(expectedTaskUpdate.updateType))
                    expect(taskUpdate).to(equal(expectedTaskUpdate.task))
                    expect(presentedScreen) === controller
                }
            }

        }
        describe("show update action modal") {
            context("when cell model on action snooze") {
                it("has expected TaskUpdateRequest and presents ViewControlller") {
                    //given
                    setupWhenGetTodaysSucceedsWithOneCategory()
                    let controller = UIViewController()
                    var onActionMock: ((TaskUpdateRequest) -> Void)?
                    screenFactoryMock.makeSnoozeModalStub = { _, onAction in
                        onActionMock = onAction
                        return controller
                    }

                    var presentedScreen: UIViewController?
                    routerMock.presentModalStub = { screen in
                        presentedScreen = screen
                    }

                    var updateAction: TaskUpdateAction?
                    var taskUpdate: Task?
                    taskServiceMock.performTaskStub = { updateType, task, taskCreateDto, completion in
                        updateAction = updateType
                        taskUpdate = task
                    }

                    //when
                    switch sut.cellModel(at: .init(item: 0, section: 0)) {
                    case let .task(cellModel):
                        cellModel.onAction?(.snooze)
                    default:
                        fail()
                    }
                    let expectedTaskUpdateRequest: TaskUpdateRequest = .stub()
                    onActionMock?(expectedTaskUpdateRequest)

                    //then
                    expect(updateAction).to(equal(expectedTaskUpdateRequest.updateType))
                    expect(taskUpdate).to(equal(expectedTaskUpdateRequest.task))
                    expect(presentedScreen) === controller
                }
            }
        }
        describe("log out") {
            it("should call auth service ") {
                var logOutCount = 0
                firebaseAuthServiceMock.logOutStub = {
                    logOutCount += 1
                }
                sut.logOut()
                expect(logOutCount) == 1
            }
        }
    }
}

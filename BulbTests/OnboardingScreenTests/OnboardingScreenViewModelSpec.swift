//
//  OnboardingScreenViewModelSpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 17/01/2023.
//

import Quick
import Nimble
@testable import Bulb

final class OnboardingScreenViewModelSpec: QuickSpec {
    override func spec() {
        var firebaseAuthServiceMock: FirebaseAuthServiceMock!
        var sut: OnboardingScreenViewModel!

        beforeEach {
            firebaseAuthServiceMock = FirebaseAuthServiceMock()
            sut = OnboardingScreenViewModel(firebaseAuthService: firebaseAuthServiceMock)
        }
        describe("content of getStarted button") {
            it("should have expected text") {
                let expectedText = "Get started"

                expect(sut.getStartedButtonModel.title).to(equal(expectedText))
            }
        }
        describe("authentication flow") {
            context("when getStartedButton pressed") {
                var lastAction: OnboardingScreenViewModel.Action?
                beforeEach {
                    sut.onAction = { newAction in  lastAction = newAction }
                    firebaseAuthServiceMock.makeAuthControllerStub = { _ in
                        return .init()
                    }
                }
                it("should present auth view controller") {
                    sut.getStartedButtonModel.action()
                    expect(lastAction) == .presentAuthController(.init(.init()))
                }
                context("when onDidSignIn is called") {
                    var onDidSignIn: (() -> Void)?
                    beforeEach {
                        firebaseAuthServiceMock.makeAuthControllerStub = { closure in
                            onDidSignIn = closure
                            return UIViewController()
                        }
                    }
                    it("should have transitionToMainScreenAction") {
                        sut.getStartedButtonModel.action()
                        onDidSignIn?()
                        expect(lastAction) == .transitionToMainScreen
                    }
                    afterEach {
                        onDidSignIn = nil
                    }
                }
                afterEach {
                    lastAction = nil
                }
            }
        }
    }
}

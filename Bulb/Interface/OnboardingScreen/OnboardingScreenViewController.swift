//
//  ViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 27/04/2022.
//

import UIKit

final class OnboardingScreenViewController: UIViewController {

    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var screenTitleStack = UIStackView()
    private lazy var getStartedButton = makeGetStartedButton()
    private lazy var bottomButtonsStack = UIStackView()

    private lazy var viewModel = OnboardingScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onAction = { [weak self] action in
            switch action {
            case let .presentAuthController(controller):
                self?.present(controller.value, animated: true)
            case .transitionToMainScreen:
                self?.view.window?.rootViewController = RootControllerFactory.makeMainScreenController()
            }
        }
        setupUI()
    }
}

// MARK: UI Setup
private extension OnboardingScreenViewController {
    func setupUI() {
        setupBackgroundImage()
        setupHierarchy()
        setupConstraints()
    }

    func setupBackgroundImage() {
        let backgroundImage = Image.homeScreenBackground
        let backgroundImageView = UIImageView.init(frame: self.view.frame)

        backgroundImageView.image = backgroundImage.uiImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.3

        self.view.insertSubview(backgroundImageView, at: 0)
    }

    func setupHierarchy() {
        screenTitleStack.translatesAutoresizingMaskIntoConstraints = false
        screenTitleStack.axis = .vertical
        screenTitleStack.backgroundColor = .none

        screenTitleStack.addArrangedSubview(titleLabel)
        screenTitleStack.addArrangedSubview(subtitleLabel)

        view.addSubview(screenTitleStack)

        bottomButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsStack.axis = .vertical

        bottomButtonsStack.addArrangedSubview(getStartedButton)
        bottomButtonsStack.setCustomSpacing(VerticalSpacing.pt22, after: getStartedButton)

        view.addSubview(bottomButtonsStack)
    }

    func setupConstraints() {
        let constraints = [
            screenTitleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitleStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        let constraintsButtonStack = [
            bottomButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -VerticalSpacing.pt68)
        ]

        NSLayoutConstraint.activate(constraintsButtonStack)
    }
}

// MARK: UI components
private extension OnboardingScreenViewController {
    func makeTitleLabel() -> UILabel {
        let titlelabel = UILabel()
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        titlelabel.attributedText = NSAttributedString(
            string: "BULB",
            attributes: [
                .font: SystemFont.Bold.ofSize42pt,
                .foregroundColor: UIColor.white
            ]
        )

        return titlelabel
    }

    func makeSubtitleLabel() -> UILabel {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.attributedText = NSAttributedString(
            string: "Grow little rockstar!",
            attributes: [
                .font: SystemFont.ofSize22pt,
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
        )

        return subtitle
    }

    func makeGetStartedButton() -> UIButton {
        let button = SimpleButton()
        button.update(model: viewModel.getStartedButtonModel)

        return button
    }
}

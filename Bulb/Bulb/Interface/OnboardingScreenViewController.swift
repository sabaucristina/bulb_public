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
    private lazy var signInButton = makeSignInButton()
    private lazy var createAccountButton = makeCreateAccountButton()
    private lazy var bottomButtonsStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: UI Setup
private extension OnboardingScreenViewController {
    func setupUI() {
        setupBackgroundImage()
        setupNavBar()
        setupHierarchy()
        setupConstraints()
    }

    func setupBackgroundImage() {
        let backgroundImage = Image.homeScreenBackground
        let backgroundImageView = UIImageView.init(frame: self.view.frame)

        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.3

        self.view.insertSubview(backgroundImageView, at: 0)
    }

    func setupNavBar() {
        navigationItem.backButtonDisplayMode = .minimal
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
        bottomButtonsStack.addArrangedSubview(signInButton)
        bottomButtonsStack.addArrangedSubview(createAccountButton)
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
        button.update(model: makeGetStartedButtonModel())

        return button
    }

    func makeGetStartedButtonModel() -> SimpleButton.Model {
        .init(
            title: "Get started",
            action: { [weak self] in
                UserDefaults.standard.set(true, forKey: "SeenOnboarding")
                self?.navigationController?
                    .setViewControllers(
                        [RootControllerFactory.makeMainScreenController()],
                        animated: false
                    )
            }
        )
    }

    func makeSignInButton() -> UIButton {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.backgroundColor = .none
        signInButton.setAttributedTitle(
            NSAttributedString(
                string: "Already a member? Sign in",
                attributes: [
                    .font: SystemFont.ofSize16pt,
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )

        return signInButton
    }

    func makeCreateAccountButton() -> UIButton {
        let createAccountButton = UIButton()
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.backgroundColor = .none
        createAccountButton.setAttributedTitle(
            NSAttributedString(
                string: "Create an account",
                attributes: [
                    .font: SystemFont.ofSize16pt,
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)

        return createAccountButton
    }

    @objc
    func createAccount() {
        navigationController?
            .pushViewController(
                CreateAccountViewController(), animated: true
            )
    }
}

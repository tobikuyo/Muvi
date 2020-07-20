//
//  OnboardingViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

enum LoginState {
    case notRegistered
    case notLoggedIn
}

class OnboardingViewController: TabViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var signInButtonLabel: UIButton!

    // MARK: - Properties

    private var isLoggedIn = false
    private var state = LoginState.notLoggedIn

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        notLoggedInState()
        setupViews()
    }

    // MARK: - Methods

    private func notLoggedInState() {
        signInButton.setTitle("SIGN IN", for: .normal)
        accountLabel.text = "Don't have an account?"
        signInButtonLabel.setTitle("Register", for: .normal)
        state = .notLoggedIn
    }

    private func notRegisteredState() {
        signInButton.setTitle("SIGN UP", for: .normal)
        accountLabel.text = "Already have an account?"
        signInButtonLabel.setTitle("Sign In", for: .normal)
        state = .notRegistered
    }

    private func setupViews() {
        OnboardingView.styleTextField(emailTextField)
        OnboardingView.styleTextField(passwordTextField)
        OnboardingView.styleFilledButton(signInButton)
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: - IBActions

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else { return }

        if state == .notLoggedIn {
            firebaseController.signIn(with: email, and: password, on: self)
        } else {
            firebaseController.signup(with: email, and: password, on: self)
        }
    }

    @IBAction func smallButtonTapped(_ sender: UIButton) {
        isLoggedIn.toggle()

        if isLoggedIn {
            notRegisteredState()
        } else {
            notLoggedInState()
        }
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

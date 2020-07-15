//
//  OnboardingViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum LoginState {
    case notRegistered
    case notLoggedIn
}

class OnboardingViewController: UIViewController {

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
        OnboardingTextField.styleTextField(emailTextField)
        OnboardingTextField.styleTextField(passwordTextField)
        OnboardingTextField.styleFilledButton(signInButton)
        passwordTextField.isSecureTextEntry = true
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func signIn(with email: String, and password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                self.presentAlert(title: "Error", message: "Unable to sign in with those details")
                NSLog("Error signing in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func signup(with email: String, and password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                self.presentAlert(title: "Error", message: "Unable to register with those details")
                NSLog("Error registering: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - IBActions

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else { return }

        if state == .notLoggedIn {
            signIn(with: email, and: password)
        } else {
            signup(with: email, and: password)
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

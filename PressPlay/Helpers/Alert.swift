//
//  Alert.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 17/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Alert {

    private static func basicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }

    static func forSignInError(_ vc: UIViewController) {
        basicAlert(on: vc, with: "Error", message: "Unable to sign in with those details")
    }

    static func forRegisterError(_ vc: UIViewController) {
        basicAlert(on: vc, with: "Error", message: "Unable to register with those details")
    }

    static func forSignout(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Signing Out",
                                      message: "Are you sure you want to sign out?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            DatabaseController.shared.signout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}

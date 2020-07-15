//
//  OnboardingTextfield.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class OnboardingTextField {
    static func styleTextField(_ textfield: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    static func styleFilledButton(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 108/255, green: 65/255, blue: 72/255, alpha: 1)
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.white
    }
}

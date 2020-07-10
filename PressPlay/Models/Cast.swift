//
//  Cast.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 10/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Cast: Codable {
    let name: String?
    let photo: String?

    enum CodingKeys: String, CodingKey {
        case name
        case photo = "profile_path"
    }
}

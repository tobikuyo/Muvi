//
//  String+Extension.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

extension String {
    var url: URL? {
        let posterURL = "https://image.tmdb.org/t/p/original"
        return URL(string:"\(posterURL)\(self)")
    }
}

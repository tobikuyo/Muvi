//
//  Movie.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String?
    let overview: String?
    let poster: String?
    let backdropPath: String?
    let voteCount: Int?
    let rating: Double?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, backdropPath, voteCount, releaseDate
        case poster = "poster_path"
        case rating = "vote_average"
    }
}

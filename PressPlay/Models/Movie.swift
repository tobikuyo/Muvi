//
//  Movie.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    let title: String?
    let overview: String?
    let poster: String?
    let backdrop: String?
    let voteCount: Int?
    let rating: Double?
    let releaseDate: String?
    let genres: [Genre]?
    let genreIDs: [Int]?
    let runtime: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, voteCount, genres, runtime
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
    }
}

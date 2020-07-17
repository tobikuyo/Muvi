//
//  Movie.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class Movie: Codable {
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
    var runtimeString: String?
    var backdropURL: String? = nil
    var genre: String?
    var isSaved: Bool?
    var documentID: String? = nil
    var imageRef: String? = nil

    enum CodingKeys: String, CodingKey {
        case id, title, overview, voteCount, genres, runtime
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
    }

    init(id: Int?, title: String?, overview: String?, poster: String?, backdrop: String?, voteCount: Int?, rating: Double?, releaseDate: String?, genres: [Genre]?, genreIDs: [Int]?, genre: String?, runtime: Int?, runtimeString: String?, backdropURL: String?, imageRef: String?, isSaved: Bool? = false) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.backdrop = backdrop
        self.voteCount = voteCount
        self.rating = rating
        self.releaseDate = releaseDate
        self.genres = genres
        self.genreIDs = genreIDs
        self.genre = genre
        self.runtime = runtime
        self.runtimeString = runtimeString
        self.backdropURL = backdropURL
        self.imageRef = imageRef
        self.isSaved = isSaved
    }
}

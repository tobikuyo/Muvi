//
//  Constants.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Fire {
    static let images       = "images"
    static let favourites   = "favourites"
    static let title        = "title"
    static let runtime      = "runtime"
    static let releaseYear  = "releaseYear"
    static let genre        = "genre"
    static let overview     = "overview"
    static let imageURL     = "imageURL"
    static let backdropURL  = "backdropURL"
    static let isSaved      = "isSaved"
    static let userID       = "userID"
    static let documentID   = "documentID"
    static let id           = "id"
    static let imageRef     = "imageRef"
    static let randomID     = "randomID"
}

struct Cell {
    static let trending   = "TrendingCell"
    static let popular    = "PopularCell"
    static let nowPlaying = "NowPlayingCell"
    static let topRated   = "TopRatedCell"
    static let cast       = "CastCell"
    static let search     = "SearchCell"
    static let savedMovie = "SavedMovieCell"
}

struct Font {
    static let pathway = "PathwayGothicOne-Regular"
    static let fira    = "FiraSansExtraCondensed-Regular"
}

struct Segue {
    static let trending    = "TrendingMovieSegue"
    static let movieDetail = "MovieDetailSegue"
}

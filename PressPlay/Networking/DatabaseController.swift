//
//  DatabaseController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 16/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase

class DatabaseController {

    private init() {}

    static let shared = DatabaseController()

    var movies: [Movie] = []

    func parse(_ snapshot: QuerySnapshot?) -> [Movie] {

        guard let documents = snapshot?.documents else { return movies }

        movies.removeAll()

        for document in documents {
            let data = document.data()

            let title = data[Fire.title] as? String ?? ""
            let overview = data[Fire.overview] as? String ?? ""
            let releaseYear = data[Fire.releaseYear] as? String ?? ""
            let genre = data[Fire.genre] as? String ?? "No Genre"
            let runtime = data[Fire.runtime] as? Int ?? 0
            let backdropURL = data[Fire.backdropURL] as? String ?? ""

            let movie = Movie(id: nil,
                              title: title,
                              overview: overview,
                              poster: nil,
                              backdrop: nil,
                              voteCount: nil,
                              rating: nil,
                              releaseDate: releaseYear,
                              genres: nil,
                              genreIDs: nil,
                              genre: genre,
                              runtime: runtime,
                              backdropURL: backdropURL)

            movies.append(movie)
        }

        return movies
    }
}

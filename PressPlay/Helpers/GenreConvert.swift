//
//  GenreConvert.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 11/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct GenreConvert {

    static func convert(_ genreIDs: [Int]) -> [String] {
        var genres: [String] = []

        for id in genreIDs {
            switch id {
            case 28:
                genres.append("Action")
            case 12:
                genres.append("Adventure")
            case 16:
                genres.append("Animation")
            case 35:
                genres.append("Comedy")
            case 80:
                genres.append("Crime")
            case 99:
                genres.append("Documentary")
            case 18:
                genres.append("Drama")
            case 10751:
                genres.append("Family")
            case 14:
                genres.append("Fantasy")
            case 36:
                genres.append("History")
            case 27:
                genres.append("Horror")
            case 10402:
                genres.append("Music")
            case 9648:
                genres.append("Mystery")
            case 10749:
                genres.append("Romance")
            case 878:
                genres.append("Science Fiction")
            case 10770:
                genres.append("TV Movie")
            case 53:
                genres.append("Thriller")
            case 10752:
                genres.append("War")
            case 37:
                genres.append("Western")
            default:
                break
            }
        }

        return genres
    }
}

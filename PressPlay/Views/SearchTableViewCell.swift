//
//  SearchTableViewCell.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 11/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!

    var movie: Movie? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let movie = movie else { return }

        let genres = GenreConvert.convert(movie.genreIDs!)
        titleLabel.text = movie.title
        genresLabel.text = genres.count > 0 ? genres.joined(separator: ", ") : "No Genres Available"
        ratingLabel.text = movie.rating?.description
        movieImageView.layer.cornerRadius = 8

        if movie.poster != nil {
            movieImageView.kf.setImage(with: movie.poster?.url)
        } else {
            movieImageView.image = UIImage(named: "noPoster")
        }
    }
}

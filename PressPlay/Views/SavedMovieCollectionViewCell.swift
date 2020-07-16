//
//  SavedMovieTableViewCell.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 16/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class SavedMovieTableViewCell: UITableViewCell {

    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    var movie: Movie? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard
            let movie = movie,
            let backdropURL = movie.backdropURL,
            let url = URL(string: backdropURL) else { return }

        titleLabel.text = movie.title
        let resource = ImageResource(downloadURL: url)
        movieImage.kf.setImage(with: resource)
        movieImage.layer.cornerRadius = 10
    }
}

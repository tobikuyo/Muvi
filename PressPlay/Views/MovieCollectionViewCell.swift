//
//  MovieCollectionViewCell.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet var posterImageView: UIImageView!

    var movie: Movie? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let movie = movie else { return }
        posterImageView.kf.setImage(with: movie.poster?.url)
        layer.cornerRadius = 15
    }
}

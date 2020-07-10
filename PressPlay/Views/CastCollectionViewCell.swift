//
//  CastCollectionViewCell.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 10/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet var actorImageView: UIImageView!
    @IBOutlet var actorNameLabel: UILabel!

    var cast: Cast? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let cast = cast else { return }
        actorNameLabel.text = cast.name
        actorImageView.kf.setImage(with: cast.photo?.url)
        actorImageView.layer.cornerRadius = actorImageView.frame.height / 2
        actorImageView.clipsToBounds = true
    }
}

//
//  MovieDetailViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 08/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var castCollectionView: UICollectionView!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func setupViews() {
        detailView.layer.cornerRadius = 10
        backdropImageView.layer.cornerRadius = 10
    }

    private func updateViews() {
        guard let movie = movie else { return }
        APIController.shared.getDetails(for: movie) { movie in
            if let movie = movie {
                self.backdropImageView.kf.setImage(with: movie.backdrop?.url)
                self.titleLabel.text = movie.title?.uppercased()
                self.runtimeLabel.text = "\(String(describing: movie.runtime!)) MIN"
                self.overviewTextView.text = movie.overview
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}

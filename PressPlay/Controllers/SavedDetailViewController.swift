//
//  SavedDetailViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 17/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class SavedDetailViewController: UIViewController {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        textViewSetup()
    }

    private func updateViews() {
        guard
            let movie = movie,
            let backdropURL = movie.backdropURL,
            let url = URL(string: backdropURL) else { return }

        titleLabel.text = movie.title
        runtimeLabel.text = movie.runtimeString
        releaseYearLabel.text = movie.releaseDate
        genreLabel.text = movie.genre
        overviewTextView.text = movie.overview

        let resource = ImageResource(downloadURL: url)
        backdropImageView.kf.setImage(with: resource)
    }

    private func textViewSetup() {
        guard let movie = movie else { return }

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        overviewTextView.attributedText = NSAttributedString(string: movie.overview!, attributes: attributes)
        overviewTextView.font = UIFont(name: Font.fira, size: 18)
        overviewTextView.textColor = .white
        overviewTextView.textAlignment = .center
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

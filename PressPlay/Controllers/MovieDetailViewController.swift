//
//  MovieDetailViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 08/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet var backButtonView: UIView!
    @IBOutlet var saveButtonView: UIView!
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

        backButtonView.layer.cornerRadius = 8
        saveButtonView.layer.cornerRadius = 8
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}

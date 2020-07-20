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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var castCollectionView: UICollectionView!
    @IBOutlet var saveButton: UIButton!

    // MARK: - Properties

    var cast: [Cast] = []
    var movie: Movie?
    var apiController: APIController?
    var firebaseController: FirebaseController?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        textViewSetup()
        getCast()
        checkSavedStatus()
    }

    // MARK: - Methods

    private func checkSavedStatus() {
        guard
            let movie = movie,
            let isSaved = movie.isSaved else { return }

        if isSaved {
            saveButton.isSelected = true
        } else {
            saveButton.isSelected = false
        }
    }

    private func updateViews() {
        guard let movie = movie else { return }

        apiController?.getDetails(for: movie) { movie in
            if let movie = movie {
                let runtimeLabel = "\(String(describing: movie.runtime!)) MIN"
                let releaseYearLabel = String((movie.releaseDate?.split(separator: "-")[0])!)
                let genreLabel = movie.genres?.first?.name?.uppercased() ?? "No Genre"

                self.backdropImageView.kf.setImage(with: movie.backdrop?.url)
                self.titleLabel.text = movie.title?.uppercased()
                self.runtimeLabel.text = runtimeLabel
                self.releaseYearLabel.text = releaseYearLabel
                self.genreLabel.text = genreLabel
                self.overviewTextView.text = movie.overview
            }
        }
    }

    private func textViewSetup() {
        guard let movie = movie else { return }

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8

        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        overviewTextView.attributedText = NSAttributedString(string: movie.overview!, attributes: attributes)
        overviewTextView.font = UIFont(name: Font.fira, size: 18)
        overviewTextView.textAlignment = .center
    }

    private func getCast() {
        guard let movie = movie else { return }

        apiController?.getCast(for: movie) { data in
            if let data = data {
                self.cast = data.cast
                self.castCollectionView.reloadData()
            }
        }
    }

    private func saveToDatabase() {
        guard
            let movie = movie,
            let title = titleLabel.text,
            let runtime = runtimeLabel.text,
            let releaseYear = releaseYearLabel.text,
            let genre = genreLabel.text,
            let overview = overviewTextView.text,
            let id = movie.id,
            let image = backdropImageView.image,
            let data = image.jpegData(compressionQuality: 1) else { return }

        firebaseController?.save(movie: movie,
                                       called: title,
                                       runtime: runtime,
                                       releaseYear: releaseYear,
                                       genre: genre,
                                       overview: overview,
                                       data: data,
                                       id: id)
    }

    private func removeMovie() {
        guard let movie = movie else { return }
        firebaseController?.remove(movie)
        firebaseController?.removeImage(for: movie)
    }


    // MARK: - IBActions

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButton.isSelected.toggle()

        if saveButton.isSelected {
            saveToDatabase()
        } else {
            removeMovie()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.cast, for: indexPath) as? CastCollectionViewCell else {
            return UICollectionViewCell()
        }

        let actor = cast[indexPath.item]
        cell.cast = actor
        return cell
    }
}

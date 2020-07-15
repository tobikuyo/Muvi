//
//  MovieDetailViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 08/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseStorage

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

    var movie: Movie?
    var isSaved: Bool?

    private var cast: [Cast] = []
    private let database = Firestore.firestore()
    private var documentID: String?
    private var imageRef: StorageReference?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        textViewSetup()
        getCast()

        if UserDefaults.standard.bool(forKey: "isSaved") == true {
            saveButton.isSelected = true
        } else {
            saveButton.isSelected = false
        }
    }

    // MARK: - Methods

    private func updateViews() {
        guard let movie = movie else { return }

        APIController.shared.getDetails(for: movie) { movie in
            if let movie = movie {
                let runtimeLabel = "\(String(describing: movie.runtime!)) MIN"
                let releaseYearLabel = String((movie.releaseDate?.split(separator: "-")[0])!)
                let genreLabel = movie.genres?.first?.name?.uppercased()

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
        overviewTextView.font = UIFont(name: "FiraSansExtraCondensed-Regular", size: 18)
        overviewTextView.textAlignment = .center
    }

    private func getCast() {
        guard let movie = movie else { return }

        APIController.shared.getCast(for: movie) { data in
            if let data = data {
                self.cast = data.cast
                self.castCollectionView.reloadData()
            }
        }
    }

    private func saveToDatabase() {
        guard
            let title = titleLabel.text,
            let runtime = runtimeLabel.text,
            let releaseYear = releaseYearLabel.text,
            let genre = genreLabel.text,
            let overview = overviewTextView.text,
            let image = backdropImageView.image,
            let data = image.jpegData(compressionQuality: 1) else { return }

        let imageName = UUID().uuidString
        let imageRef = Storage.storage()
            .reference()
            .child(Fire.images)
            .child(imageName)

        self.imageRef = imageRef

        imageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                NSLog("Error saving image data: \(error.localizedDescription)")
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    NSLog("Error getting url for saved imgae: \(error.localizedDescription)")
                    return
                }

                guard let url = url else { return }

                let favouritesRef = self.database.collection(Fire.favourites).document()
                let documentID = favouritesRef.documentID
                self.documentID = documentID

                favouritesRef.setData([
                    Fire.title: title,
                    Fire.runtime: runtime,
                    Fire.releaseYear: releaseYear,
                    Fire.genre: genre,
                    Fire.overview: overview,
                    Fire.imageURL: url.absoluteString,
                    Fire.userID: Auth.auth().currentUser?.uid ?? "",
                    Fire.documentID: documentID

                ]) { error in
                    if let error = error {
                        NSLog("Error adding movie: \(error.localizedDescription)")
                    } else {
                        UserDefaults.standard.set(true, forKey: "isSaved")
                    }
                }
            }
        }
    }

    private func removeFromDatabase() {
        guard let documentID = documentID else { return }

        self.database
            .collection(Fire.favourites)
            .document(documentID)
            .delete { error in
                if let error = error {
                    NSLog("Error removing document: \(error.localizedDescription)")
                } else {
                    UserDefaults.standard.set(false, forKey: "isSaved")
                }
        }
    }

    private func removeImageFromStorage() {
        guard let imageRef = imageRef else { return }

        imageRef.delete { error in
            if let error = error {
                NSLog("Error removing images: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - IBActions

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if saveButton.isSelected {
            saveToDatabase()
        } else {
            removeFromDatabase()
            removeImageFromStorage()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as? CastCollectionViewCell else {
            return UICollectionViewCell()
        }

        let actor = cast[indexPath.item]
        cell.cast = actor
        return cell
    }
}

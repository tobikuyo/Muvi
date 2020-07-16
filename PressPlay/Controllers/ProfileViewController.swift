//
//  ProfileViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    private var movies: [Movie] = []
    private var moviesListener: ListenerRegistration!
    private let moviesCollectionRef = Firestore.firestore().collection(Fire.favourites)

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.overrideUserInterfaceStyle = .dark
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movies.removeAll()

        if moviesListener != nil {
            moviesListener.remove()
        }
    }

    // MARK: - Methods

    private func fetchMovies() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        moviesListener = moviesCollectionRef
            .whereField(Fire.userID, isEqualTo: userID)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    NSLog("Error fetching movies from Firebase: \(error)")
                } else {
                    self.movies = DatabaseController.shared.parse(snapshot)
                    self.tableView.reloadData()
                }
            })
    }

    @IBAction func signoutTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)

        do {
            try Auth.auth().signOut()
        } catch {
            NSLog("Error signing out: \(error)")
        }
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMovieCell", for: indexPath) as? SavedMovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.item]
        cell.movie = movie
        return cell
    }
}

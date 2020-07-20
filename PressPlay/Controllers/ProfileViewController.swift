//
//  ProfileViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 15/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var movies: [Movie] = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.overrideUserInterfaceStyle = .dark
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
        emptyTableViewSetup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseController.shared.removeListener()
    }

    // MARK: - Methods

    private func fetchMovies() {
        FirebaseController.shared.fetch { movies in
            guard let movies = movies else { return }
            self.movies = movies
            self.tableView.reloadData()
        }
    }

    private func emptyTableViewSetup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }

    @IBAction func signoutTapped(_ sender: UIButton) {
        Alert.forSignout(self)
    }

    //  MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.movieDetail {
            if let destinationVC = segue.destination as? SavedDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let movie = movies[indexPath.row]
                destinationVC.movie = movie
            }
        }
    }
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.savedMovie, for: indexPath) as? SavedMovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.item]
        cell.movie = movie
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = movies[indexPath.row]
            FirebaseController.shared.remove(movie)
            FirebaseController.shared.removeImage(for: movie)
        }
    }
}

extension ProfileViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "NO SAVED MOVIES"
        let attrs = [NSAttributedString.Key.font: UIFont(name: Font.pathway, size: 22)!,
                     NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "noMovies")
    }
}

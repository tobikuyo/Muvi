//
//  SearchViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 11/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    private var movies: [Movie] = []
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.autocapitalizationType = .words
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }

        APIController.shared.searchForMovie(called: query, on: page) { data in
            if let data = data {
                self.movies = data.results
                self.tableView.reloadData()
            }
        }
    }
}

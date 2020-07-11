//
//  SearchViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 11/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    private var movies: [Movie] = []
    private var totalPages = 0
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        emptyTableViewSetup()
    }

    private func searchBarSetup() {
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.autocapitalizationType = .words
    }

    private func emptyTableViewSetup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == movies.count - 1 {
            if page < totalPages {
                page += 1
                OperationQueue.main.addOperation {
                    guard let query = self.searchBar.text else { return }
                    APIController.shared.searchForMovie(called: query, on: self.page) { data in
                        guard let data = data else { return }
                        self.movies += data.results
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }

        APIController.shared.searchForMovie(called: query, on: page) { data in
            if let data = data {
                self.movies = data.results
                self.totalPages = data.totalPages
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "SEARCH FOR A MOVIE"
        let attrs = [NSAttributedString.Key.font: UIFont(name: "PathwayGothicOne-Regular", size: 20)!,
                     NSAttributedString.Key.foregroundColor: UIColor.white]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptySearch")
    }
}

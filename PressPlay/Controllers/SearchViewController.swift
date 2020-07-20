//
//  SearchViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 11/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchViewController: TabViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    private var movies: [Movie] = []
    private var totalPages = 0
    private var page = 1

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        emptyTableViewSetup()
        navigationController?.overrideUserInterfaceStyle = .dark
    }

    // MARK: - Methods

    private func searchBarSetup() {
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.autocapitalizationType = .words
        searchBar.searchTextField.font = UIFont(name: Font.fira, size: 20)
    }

    private func emptyTableViewSetup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.movieDetail {
            if let destinationVC = segue.destination as? MovieDetailViewController,
                let indexPath = tableView.indexPathsForSelectedRows?.first {
                let movie = movies[indexPath.row]
                destinationVC.movie = movie
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.search, for: indexPath) as? SearchTableViewCell else {
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
                    self.apiController.searchForMovie(called: query, on: self.page) { data in
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

        apiController.searchForMovie(called: query, on: page) { data in
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
        let str = "NO SEARCH RESULTS"
        let attrs = [NSAttributedString.Key.font: UIFont(name: Font.pathway, size: 22)!,
                     NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptySearch")
    }
}

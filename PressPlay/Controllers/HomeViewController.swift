//
//  HomeViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet var trendingMovieImage: UIImageView!
    @IBOutlet var trendingCollectionView: UICollectionView!
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    @IBOutlet var topRatedCollectionView: UICollectionView!

    // MARK: - Properties

    private var page = 1
    private var popularTotalPages = 0
    private var topRatedTotalPages = 0
    private var nowPlayingTotalPages = 0
    private var trendingTotalPages = 0

    private var popularMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var trendingMovies: [Movie] = []

    private let popular = "popular"
    private let topRated = "top_rated"
    private let nowPlaying = "now_playing"
    private let trending = "trending"

    private var trendingMovie: Movie? {
        didSet {
            self.trendingMovieImage.kf.setImage(with: trendingMovie?.backdrop?.url)
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrendingMovies()
        fetchAllSections()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Methods

    private func setupViews() {
        navigationController?.overrideUserInterfaceStyle = .dark
        trendingMovieImage.layer.cornerRadius = 15
    }

    private func fetchTrendingMovies() {
        APIController.shared.fetchTrendingMovie(on: page) { data in
            guard let data = data else { return }
            self.trendingMovies = data.results
            self.trendingMovie = data.results[Int.random(in: 5...15)]
            self.trendingTotalPages = data.totalPages
            self.trendingCollectionView.reloadData()
        }
    }

    private func fetchAllSections() {
        fetchMovies(forSection: popular)
        fetchMovies(forSection: topRated)
        fetchMovies(forSection: nowPlaying)
    }

    private func fetchMovies(forSection section: String, onPage: Int = 1) {
        APIController.shared.fetchMovies(forSection: section, on: page) { data in
            guard let data = data else { return }

            switch section {
            case self.popular:
                self.popularMovies = data.results
                self.popularTotalPages = data.totalPages
                self.popularCollectionView.reloadData()

            case self.topRated:
                self.topRatedMovies = data.results
                self.topRatedTotalPages = data.totalPages
                self.topRatedCollectionView.reloadData()

            default:
                self.nowPlayingMovies = data.results
                self.nowPlayingTotalPages = data.totalPages
                self.nowPlayingCollectionView.reloadData()
            }
        }
    }

    private func checkForMore(_ movies: [Movie],
                              using pages: Int,
                              at indexPath: IndexPath) {
        if indexPath.item == trendingMovies.count - 1{
            loadMoreTrendingMovies()
        }
    }

    func loadMoreTrendingMovies() {
        if page < trendingTotalPages {
            page += 1
            OperationQueue.main.addOperation {
                APIController.shared.fetchTrendingMovie(on: self.page) { data in
                    guard let data = data else { return }
                    self.trendingMovies += data.results
                    self.trendingCollectionView.reloadData()
                }
            }
        }
    }

    private func checkForMore(_ movies: [Movie],
                              for section: String,
                              using pages: Int,
                              at indexPath: IndexPath) {
        if indexPath.item == movies.count - 1 {
            self.loadMoreMovies(forSection: section, pages)
        }
    }

    private func loadMoreMovies(forSection section: String, _ totalPages: Int) {
        if page < totalPages {
            page += 1
            OperationQueue.main.addOperation {
                APIController.shared.fetchMovies(forSection: section, on: self.page) { data in
                    guard let data = data else { return }

                    switch section {
                    case self.popular:
                        self.popularMovies += data.results
                        self.popularCollectionView.reloadData()

                    case self.topRated:
                        self.topRatedMovies += data.results
                        self.topRatedCollectionView.reloadData()

                    default:
                        self.nowPlayingMovies += data.results
                        self.nowPlayingCollectionView.reloadData()
                    }
                }
            }
        }
    }

    private func cell(for collectionView: UICollectionView,
                      with movies: [Movie],
                      andIdentifier identifier: String,
                      for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case trendingCollectionView:
            return trendingMovies.count
        case popularCollectionView:
            return popularMovies.count
        case nowPlayingCollectionView:
            return nowPlayingMovies.count
        default:
            return topRatedMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case trendingCollectionView:
            return cell(for: trendingCollectionView, with: trendingMovies, andIdentifier: "TrendingCell", for: indexPath)
        case popularCollectionView:
            return cell(for: popularCollectionView, with: popularMovies, andIdentifier: "PopularCell", for: indexPath)
        case nowPlayingCollectionView:
            return cell(for: nowPlayingCollectionView, with: nowPlayingMovies, andIdentifier: "NowPlayingCell", for: indexPath)
        default:
            return cell(for: topRatedCollectionView, with: topRatedMovies, andIdentifier: "TopRatedCell", for: indexPath)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        checkForMore(popularMovies, for: popular, using: popularTotalPages, at: indexPath)
        checkForMore(topRatedMovies, for: topRated, using: topRatedTotalPages, at: indexPath)
        checkForMore(nowPlayingMovies, for: nowPlaying, using: nowPlayingTotalPages, at: indexPath)
        checkForMore(trendingMovies, using: trendingTotalPages, at: indexPath)
    }
}

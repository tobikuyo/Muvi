//
//  HomeViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Kingfisher
import DZNEmptyDataSet
import Firebase

class HomeViewController: TabViewController {

    @IBOutlet var trendingMovieImage: UIImageView!
    @IBOutlet var trendingCollectionView: UICollectionView!
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    @IBOutlet var topRatedCollectionView: UICollectionView!

    // MARK: - Properties

    private var page = 1
    private var trendingPage = 1
    private var popularTotalPages = 0
    private var nowPlayingTotalPages = 0
    private var topRatedTotalPages = 0

    private var trendingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []

    private let popular = "popular"
    private let nowPlaying = "now_playing"
    private let topRated = "top_rated"

    private var handle: AuthStateDidChangeListenerHandle?

    private var trendingMovie: Movie? {
        didSet {
            trendingMovieImage.kf.setImage(with: trendingMovie?.backdrop?.url)
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoginState()
        setupViews()
        emptyCollectionViewSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Methods

    @objc func trendingImageTapped() {
        performSegue(withIdentifier: Segue.trending, sender: self)
    }

    private func setupViews() {
        navigationController?.overrideUserInterfaceStyle = .dark
        trendingMovieImage.layer.cornerRadius = 15

        let tap = UITapGestureRecognizer(target: self, action: #selector(trendingImageTapped))
        trendingMovieImage.addGestureRecognizer(tap)
        trendingMovieImage.isUserInteractionEnabled = true
    }

    private func emptyCollectionViewSetup() {
        trendingCollectionView.emptyDataSetSource = self
        trendingCollectionView.emptyDataSetDelegate = self
    }

    private func checkLoginState() {
        handle = Auth.auth().addStateDidChangeListener({ _, user in
            if user == nil {
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
                onboardingVC.modalPresentationStyle = .fullScreen
                self.present(onboardingVC, animated: true, completion: nil)
            } else {
                self.fetchTrendingMovies()
                self.fetchAllSections()
            }
        })
    }

    private func fetchTrendingMovies() {
        apiController.fetchTrendingMovies(on: trendingPage) { data in
            guard let data = data else { return }
            self.trendingMovies = data.results
            self.trendingMovie = data.results[Int.random(in: 3...19)]
            self.trendingCollectionView.reloadData()
        }
    }

    private func fetchAllSections() {
        fetchMovies(forSection: popular)
        fetchMovies(forSection: nowPlaying)
        fetchMovies(forSection: topRated)
    }

    private func fetchMovies(forSection section: String, onPage: Int = 1) {
        apiController.fetchMovies(forSection: section, on: page) { data in
            guard let data = data else { return }

            switch section {
            case self.popular:
                self.popularMovies = data.results
                self.popularTotalPages = data.totalPages
                self.popularCollectionView.reloadData()

            case self.nowPlaying:
                self.nowPlayingMovies = data.results
                self.nowPlayingTotalPages = data.totalPages
                self.nowPlayingCollectionView.reloadData()

            default:
                self.topRatedMovies = data.results
                self.topRatedTotalPages = data.totalPages
                self.topRatedCollectionView.reloadData()
            }
        }
    }

    private func checkForMore(_ movies: [Movie], at indexPath: IndexPath) {
        if indexPath.item == trendingMovies.count - 1 {
            if trendingPage < 3  {
                trendingPage += 1
                OperationQueue.main.addOperation {
                    self.apiController.fetchTrendingMovies(on: self.trendingPage) { data in
                        guard let data = data else { return }
                        self.trendingMovies += data.results
                        self.trendingCollectionView.reloadData()
                    }
                }
            }
        }
    }

    private func checkForMore(_ movies: [Movie],
                              for section: String,
                              using pages: Int,
                              at indexPath: IndexPath) {
        if indexPath.item == movies.count - 1 {
            loadMoreMovies(for: section, using: pages)
        }
    }

    private func loadMoreMovies(for section: String, using totalPages: Int) {
        if page < totalPages {
            page += 1
            OperationQueue.main.addOperation {
                self.apiController.fetchMovies(forSection: section, on: self.page) { data in
                    guard let data = data else { return }

                    switch section {
                    case self.popular:
                        self.popularMovies += data.results
                        self.popularCollectionView.reloadData()

                    case self.nowPlaying:
                        self.nowPlayingMovies += data.results
                        self.nowPlayingCollectionView.reloadData()

                    default:
                        self.topRatedMovies += data.results
                        self.topRatedCollectionView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    private func prepare(_ segue: UIStoryboardSegue,
                         for collectionView: UICollectionView,
                         using cell: UICollectionViewCell,
                         and tag: Int,
                         for movies: [Movie]) {
        if cell.tag == tag {
            if let destinationVC = segue.destination as? MovieDetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let movie = movies[indexPath.item]
                destinationVC.movie = movie
                destinationVC.apiController = apiController
                destinationVC.firebaseController = firebaseController
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.trending {
            guard let destinationVC = segue.destination as? MovieDetailViewController else { return }
            destinationVC.movie = trendingMovie
            destinationVC.apiController = apiController
            destinationVC.firebaseController = firebaseController
        } else {
            let cell = sender as! UICollectionViewCell
            prepare(segue, for: trendingCollectionView, using: cell, and: 0, for: trendingMovies)
            prepare(segue, for: popularCollectionView, using: cell, and: 1, for: popularMovies)
            prepare(segue, for: nowPlayingCollectionView, using: cell, and: 2, for: nowPlayingMovies)
            prepare(segue, for: topRatedCollectionView, using: cell, and: 3, for: topRatedMovies)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case trendingCollectionView:
            return trendingMovies.count
        case popularCollectionView:
            return popularMovies.count
        case topRatedCollectionView:
            return topRatedMovies.count
        default:
            return nowPlayingMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case trendingCollectionView:
            return cell(for: trendingCollectionView, with: trendingMovies, andIdentifier: Cell.trending, at: indexPath)
        case popularCollectionView:
            return cell(for: popularCollectionView, with: popularMovies, andIdentifier: Cell.popular, at: indexPath)
        case nowPlayingCollectionView:
            return cell(for: nowPlayingCollectionView, with: nowPlayingMovies, andIdentifier: Cell.nowPlaying, at: indexPath)
        default:
            return cell(for: topRatedCollectionView, with: topRatedMovies, andIdentifier: Cell.topRated, at: indexPath)
        }
    }

    func cell(for collectionView: UICollectionView,
              with movies: [Movie],
              andIdentifier identifier: String,
              at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        checkForMore(trendingMovies, at: indexPath)
        checkForMore(popularMovies, for: popular, using: popularTotalPages, at: indexPath)
        checkForMore(nowPlayingMovies, for: nowPlaying, using: nowPlayingTotalPages, at: indexPath)
        checkForMore(topRatedMovies, for: topRated, using: topRatedTotalPages, at: indexPath)
    }
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "NO INTERNET CONNECTION"
        let attrs = [NSAttributedString.Key.font: UIFont(name: Font.pathway, size: 20)!,
                     NSAttributedString.Key.foregroundColor: UIColor.white]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "noInternet")
    }
}

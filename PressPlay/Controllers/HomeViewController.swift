//
//  HomeViewController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var trendingMovieImage: UIImageView!
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var topRatedCollectionView: UICollectionView!
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    @IBOutlet var comingSoonCollectionView: UICollectionView!

    // MARK: - Properties

    private var page = 1
    private var popularTotalPages = 0
    private var topRatedTotalPages = 0
    private var nowPlayingTotalPages = 0
    private var upcomingTotalPages = 0

    private var popularMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        case popularCollectionView:
            return popularMovies.count
        case topRatedCollectionView:
            return topRatedMovies.count
        case nowPlayingCollectionView:
            return nowPlayingMovies.count
        default:
            return upcomingMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularCollectionView:
            return cell(for: popularCollectionView, with: popularMovies, andIdentifier: "PopularCell", for: indexPath)
        case topRatedCollectionView:
            return cell(for: topRatedCollectionView, with: topRatedMovies, andIdentifier: "TopRatedCell", for: indexPath)
        case nowPlayingCollectionView:
            return cell(for: nowPlayingCollectionView, with: nowPlayingMovies, andIdentifier: "NowPlayingCell", for: indexPath)
        case comingSoonCollectionView:
            return cell(for: comingSoonCollectionView, with: upcomingMovies, andIdentifier: "UpcomingCell", for: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
}

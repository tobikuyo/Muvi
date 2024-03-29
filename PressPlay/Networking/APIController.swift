//
//  APIController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class APIController {

    private let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private let apiKey = "435b8518a5ca880ce95403657741f93d"

    func fetchMovies(forSection section: String, on page: Int, completion: @escaping (Results?) -> Void) {
        let url = baseURL
            .appendingPathComponent("movie")
            .appendingPathComponent(section)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let pageQuery = URLQueryItem(name: "page", value: page.description)
        components?.queryItems = [apiKeyQuery, pageQuery]

        guard let requestURL = components?.url else {
            NSLog("Error with request URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error with request to fetch movies: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                NSLog("No movie data returned from data task")
                completion(nil)
                return
            }

            do {
                let movies = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async { completion(movies) }
            } catch {
                NSLog("Error decoding movies data: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchTrendingMovies(on page: Int, completion: @escaping (Results?) -> Void) {
        let url = baseURL
            .appendingPathComponent("trending")
            .appendingPathComponent("movie")
            .appendingPathComponent("day")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let pageQuery = URLQueryItem(name: "page", value: page.description)
        components?.queryItems = [apiKeyQuery, pageQuery]

        guard let requestURL = components?.url else {
            NSLog("Error with request URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error with request to fetch trending movie: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                NSLog("No movie data returned from data task")
                completion(nil)
                return
            }

            do {
                let movies = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async { completion(movies) }
            } catch {
                NSLog("Error decoding trending movies data: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func getDetails(for movie: Movie, completion: @escaping (Movie?) -> Void) {
        let url = baseURL
            .appendingPathComponent("movie")
            .appendingPathComponent(movie.id!.description)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        components?.queryItems = [apiKeyQuery]

        guard let requestURL = components?.url else {
            NSLog("Error with request URL to get details")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error with request to fetch movie details: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                NSLog("No movie data returned from data task")
                completion(nil)
                return
            }

            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async { completion(movie) }
            } catch {
                NSLog("Error decoding movie details data: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func getCast(for movie: Movie, completion: @escaping (Credits?) -> Void) {
        let url = baseURL
            .appendingPathComponent("movie")
            .appendingPathComponent(movie.id!.description)
            .appendingPathComponent("credits")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        components?.queryItems = [apiKeyQuery]

        guard let requestURL = components?.url else {
            NSLog("Error with request URL to get cast")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error with request to fetch cast details: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                NSLog("No cast data returned from data task")
                completion(nil)
                return
            }

            do {
                let cast = try JSONDecoder().decode(Credits.self, from: data)
                DispatchQueue.main.async { completion(cast) }
            } catch {
                NSLog("Error decoding cast data: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func searchForMovie(called name: String, on page: Int, completion: @escaping (Results?) -> Void) {
        let url = baseURL
            .appendingPathComponent("search")
            .appendingPathComponent("movie")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let movieQuery = URLQueryItem(name: "query", value: name)
        let pageQuery = URLQueryItem(name: "page", value: page.description)
        components?.queryItems = [apiKeyQuery, movieQuery, pageQuery]

        guard let requestURL = components?.url else {
            NSLog("Error with request URL to search \(name)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error with request to search \(name): \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                NSLog("No search results returned")
                completion(nil)
                return
            }

            do {
                let movies = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async { completion(movies) }
            } catch {
                NSLog("Error decoding search results: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

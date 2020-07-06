//
//  APIController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 06/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class APIController {

    private init() {}

    static let shared = APIController()

    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie/")!
    private let apiKey = "435b8518a5ca880ce95403657741f93d"

    func fetchMovies(forSection section: String, on page: Int, completion: @escaping (Results?) -> Void) {
        let url = baseURL.appendingPathComponent(section)
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
                NSLog("Error decoding movie data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

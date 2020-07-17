//
//  DatabaseController.swift
//  PressPlay
//
//  Created by Tobi Kuyoro on 16/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Kingfisher

class DatabaseController {

    private init() {}

    // MARK: - Properties

    static let shared = DatabaseController()

    var movies: [Movie] = []
    private let database = Firestore.firestore()
    private var moviesListener: ListenerRegistration!

    // MARK: - Authentication

    func signIn(with email: String, and password: String, on vc: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                Alert.forSignInError(vc)
                NSLog("Error signing in: \(error.localizedDescription)")
            } else {
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }

    func signup(with email: String, and password: String, on vc: UIViewController) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                Alert.forRegisterError(vc)
                NSLog("Error registering: \(error.localizedDescription)")
            } else {
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }

    func signout() {
        do {
            try Auth.auth().signOut()
        } catch {
            NSLog("Error signing out: \(error)")
        }
    }

    // MARK: - Database

    func save(movie: Movie, called title: String, runtime: String, releaseYear: String, genre: String, overview: String, data: Data, id: Int) {
        let imageName = UUID().uuidString
        let imageRef = Storage.storage()
            .reference()
            .child(Fire.images)
            .child(imageName)

        imageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                NSLog("Error saving image data: \(error.localizedDescription)")
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    NSLog("Error getting url for saved imgae: \(error.localizedDescription)")
                    return
                }

                guard let url = url else { return }

                let favouritesRef = self.database.collection(Fire.favourites).document()
                let documentID = favouritesRef.documentID

                favouritesRef.setData([
                    Fire.id: id,
                    Fire.title: title,
                    Fire.runtime: runtime,
                    Fire.releaseYear: releaseYear,
                    Fire.genre: genre,
                    Fire.overview: overview,
                    Fire.backdropURL: url.absoluteString,
                    Fire.userID: Auth.auth().currentUser?.uid ?? "",
                    Fire.documentID: documentID,
                    Fire.imageRef: imageRef.name
                ]) { error in
                    if let error = error {
                        NSLog("Error adding movie: \(error.localizedDescription)")
                    } else {
                        movie.isSaved = true
                        movie.documentID = documentID
                    }
                }
            }
        }
    }

    func fetch(completion: @escaping ([Movie]?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        moviesListener = database
            .collection(Fire.favourites)
            .whereField(Fire.userID, isEqualTo: userID)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    NSLog("Error fetching movies from Firebase: \(error)")
                    completion(nil)
                } else {
                    let movies = self.parse(snapshot)
                    completion(movies)
                }
            })
    }

    func parse(_ snapshot: QuerySnapshot?) -> [Movie] {
        guard let documents = snapshot?.documents else { return movies }
        movies.removeAll()

        for document in documents {
            let data = document.data()

            let title = data[Fire.title] as? String ?? ""
            let overview = data[Fire.overview] as? String ?? ""
            let releaseYear = data[Fire.releaseYear] as? String ?? ""
            let genre = data[Fire.genre] as? String ?? "No Genre"
            let runtimeString = data[Fire.runtime] as? String ?? ""
            let backdropURL = data[Fire.backdropURL] as? String ?? ""
            let id = data[Fire.id] as? Int ?? 0
            let imageRef = data[Fire.imageRef] as? String ?? ""
            let documentID = data[Fire.documentID] as? String ?? ""

            let movie = Movie(id: id,
                              title: title,
                              overview: overview,
                              poster: nil,
                              backdrop: nil,
                              voteCount: nil,
                              rating: nil,
                              releaseDate: releaseYear,
                              genres: nil,
                              genreIDs: nil,
                              genre: genre,
                              runtime: nil,
                              runtimeString: runtimeString,
                              backdropURL: backdropURL,
                              imageRef: imageRef)

            movie.documentID = documentID
            movies.append(movie)
        }

        return movies
    }

    func remove(movie: Movie) {
        guard let documentID = movie.documentID else { return }

        database.collection(Fire.favourites)
            .document(documentID)
            .delete { error in
                if let error = error {
                    NSLog("Error removing document: \(error.localizedDescription)")
                } else {
                    movie.isSaved = false
                }
        }
    }

    func removeListener() {
        if moviesListener != nil {
            moviesListener.remove()
        }
    }

    // MARK: - Storage

    func removeImage(for movie: Movie) {
        guard let imageRef = movie.imageRef else { return }

        let storageRef = Storage.storage()
            .reference()
            .child(Fire.images)
            .child(imageRef)

        storageRef.delete { error in
            if let error = error {
                NSLog("Error removing images: \(error.localizedDescription)")
            }
        }
    }
}

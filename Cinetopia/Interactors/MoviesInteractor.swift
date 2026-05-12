//
//  MoviesInteractor.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 12/05/26.
//


protocol MoviesInteractorProtocol: AnyObject {
    func fetchMovies() async throws -> [Movie]
}

class MoviesInteractor: MoviesInteractorProtocol {
    
    private let movieService: MovieService = MovieService()
    
    func fetchMovies() async throws -> [Movie] {
        do {
            let movies = try await movieService.getMovies()
            return movies
        } catch (let error) {
            throw error
        }
    }
}


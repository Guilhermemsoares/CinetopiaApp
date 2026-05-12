//
//  MoviesPresenter.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 12/05/26.
//

import Foundation
import UIKit

protocol MoviesPresenterToViewControllerProtocol: AnyObject {
    func setViewController(_ viewController: MoviesViewControllerToPresenterProtocol)
    func viewDidLoad()
    func viewDidAppear()
}

protocol MoviesPresenterToViewProtocol: AnyObject {
    func didSelect(movie: Movie)
    func didSelectFavoriteButton(movie: Movie)
    func didSearchText(_ searchBar: UISearchBar, textDidChange searchText: String, movies: [Movie], _ filteredMovies: inout [Movie])
}

class MoviesPresenter: MoviesPresenterToViewControllerProtocol {
    
    // MARK: - Attributes
    
    private var controller: MoviesViewControllerToPresenterProtocol?
    private var view: MoviesViewProtocol?
    private var interactor: MoviesInteractorProtocol?
    
    // MARK: - Init
    init(view: MoviesViewProtocol, interactor: MoviesInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - MoviesPresenterToViewControllerProtocol Implementation
    
    func setViewController(_ viewController: any MoviesViewControllerToPresenterProtocol) {
        self.controller = viewController
    }
    
    func viewDidLoad() {
        view?.setPresenter(self)
        Task {
            await fetchMovies()
        }
    }
    
    func viewDidAppear() {
        view?.reloadData()
    }
    
    // MARK: - Class Methods
    private func fetchMovies() async {
        do {
            guard let movies = try await interactor?.fetchMovies() else {
                return
            }
            view?.setupView(with: movies)
            view?.reloadData()
        } catch (let error) {
            print(error)
        }
    }
}

extension MoviesPresenter: MoviesPresenterToViewProtocol {
    func didSelect(movie: Movie) {
        controller?.didSelectMovie(movie)
    }
    
    func didSelectFavoriteButton(movie: Movie) {
        movie.changeSelectionStatus()
        MovieManager.shared.add(movie)
    }
    
    func didSearchText(_ searchBar: UISearchBar, textDidChange searchText: String, movies: [Movie], _ filteredMovies: inout [Movie]) {
        if searchText.isEmpty {
            view?.toggle(false)
        } else {
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
            view?.toggle(true)
        }
    }
}

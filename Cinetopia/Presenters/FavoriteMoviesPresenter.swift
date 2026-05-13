//
//  FavoriteMoviesPresenter.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 13/05/26.
//

import UIKit

protocol FavoriteMoviesPresenterToFavoriteViewControllerProtocol: AnyObject {
    func setViewController(_ viewController: FavoriteMovieViewControllerToPresenterProtocol)
    func viewDidLoad()
    func viewDidAppear()
}

protocol FavoriteMoviesPresenterToFavoriteViewProtocol: AnyObject {
}

class FavoriteMoviesPresenter:FavoriteMoviesPresenterToFavoriteViewControllerProtocol {
    
    private var controller: FavoriteMovieViewControllerToPresenterProtocol?
    private var view: FavoriteMoviesViewToPresenterProtocol?
//    private var interactor: MoviesInteractorProtocol?
    
    // MARK: - Init
    init(view: FavoriteMoviesViewToPresenterProtocol) {
        self.view = view
    }
    
    
    func setViewController(_ viewController: any FavoriteMovieViewControllerToPresenterProtocol) {
        self.controller = viewController
    }
    
    func viewDidLoad() {
        view?.setPresenter(self)
    }
    
    func viewDidAppear() {
        view?.reloadData()
    }
    
}

extension FavoriteMoviesPresenter: FavoriteMoviesPresenterToFavoriteViewProtocol {

}

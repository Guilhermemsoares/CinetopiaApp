//
//  FavoriteMoviesViewController.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 05/05/26.
//

import UIKit

protocol FavoriteMovieViewControllerToPresenterProtocol: AnyObject {
    func didSelectMovie(_ movie: Movie)
}


class FavoriteMoviesViewController: UIViewController {
    
    private var presenter: FavoriteMoviesPresenterToFavoriteViewControllerProtocol?
    
    private var mainView: FavoriteMoviesView?
    
    // Dependency injection to comunicate with presenter
    init(view: FavoriteMoviesView, presenter: FavoriteMoviesPresenterToFavoriteViewControllerProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.mainView = view
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .background
        presenter?.setViewController(self)
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

extension FavoriteMoviesViewController: FavoriteMovieViewControllerToPresenterProtocol {
    func didSelectMovie(_ movie: Movie) {
        let detailsVC = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

//
//  TabBarController.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 07/05/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - Class methods
    
    private func setupTabBarController() {
        let view = MoviesView()
        let interactor = MoviesInteractor()
        let presenter = MoviesPresenter(view: view, interactor: interactor)
        let home = UINavigationController(rootViewController: MoviesViewController(view: view, presenter: presenter))
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        
        let homeSymbol = UIImage(systemName: "film", withConfiguration: symbolConfiguration)
        home.tabBarItem.image = homeSymbol
        home.tabBarItem.title = "Movies List"
        
        let favoriteView = FavoriteMoviesView()
        let favoritePresenter = FavoriteMoviesPresenter(view: favoriteView)
        let favorites = UINavigationController(rootViewController: FavoriteMoviesViewController(view: favoriteView, presenter: favoritePresenter))
        
        let heartSymbol = UIImage(systemName: "heart", withConfiguration: symbolConfiguration)
        favorites.tabBarItem.image = heartSymbol
        favorites.tabBarItem.title = "Favorites"
        
        self.setViewControllers([home, favorites], animated: true)
    }
    
}

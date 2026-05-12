//
//  MoviesView.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 12/05/26.
//

import UIKit

protocol MoviesViewProtocol: AnyObject {
    func setPresenter(_ presenter: MoviesPresenterToViewProtocol)
    func setupView(with movies: [Movie])
    func reloadData()
    func reloadRow(at indexPath: IndexPath)
    func toggle(_ isActive: Bool)
}

class MoviesView: UIView {
    
    // MARK: - Attributes
    private var filteredMovies: [Movie] = []
    private var isSearchActive: Bool = false
    private var movies: [Movie] = []
    
    private var presenter: MoviesPresenterToViewProtocol?
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return tableView
    }()
    
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Class Methods
    
    private func addSubviews() {
        // We will not use view.addSubview because we are already inside the view
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        // We will not use view.leadingAnchor.. or any view. because we are already inside the view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}


extension MoviesView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredMovies.count : movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell {
            let movie = isSearchActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
            cell.configureCell(movie: movie)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = isSearchActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
        presenter?.didSelect(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension MoviesView: MovieTableViewCellDelegate {
    func didSelectFavoriteButton(sender: UIButton) {
        guard let cell = sender.superview?.superview as? MovieTableViewCell else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let selectedMovie = movies[indexPath.row]
        
        presenter?.didSelectFavoriteButton(movie: selectedMovie)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension MoviesView: MoviesViewProtocol {
    func setPresenter(_ presenter: any MoviesPresenterToViewProtocol) {
        self.presenter = presenter
    }
    
    func setupView(with movies: [Movie]) {
        self.movies = movies
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
  
    func reloadRow(at indexPath: IndexPath) {
        // Reload the selected row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func toggle(_ isActive: Bool) {
        self.isSearchActive = isActive
    }
}

extension MoviesView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didSearchText(searchBar, textDidChange: searchText, movies: movies, &filteredMovies)
        tableView.reloadData()
    }
}

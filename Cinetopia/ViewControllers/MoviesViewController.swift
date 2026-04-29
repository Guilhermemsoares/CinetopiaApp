//
//  MoviesViewController.swift
//  Cinetopia
//
//  Created by Giovanna Moeller on 30/10/23.
//

import UIKit

class MoviesViewController: UIViewController {
    
    private var filteredMovies: [Movie] = []
    private var isSearchActive: Bool = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Movie"
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .gray
        searchBar.delegate = self
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Filmes Populares"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = searchBar
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive && filteredMovies.isEmpty {
            return 1 // one “no results” row
        }
        return isSearchActive ? filteredMovies.count : movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchActive && filteredMovies.isEmpty {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "emptyCell")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textLabel?.text = "No results"
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.detailTextLabel?.text = "Try a different title or check your spelling."
            cell.detailTextLabel?.textColor = .black
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textAlignment = .center
            cell.detailTextLabel?.textAlignment = .center
            return cell
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = isSearchActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.configureCell(movie: movie)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = isSearchActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
        let detailsVC = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            filteredMovies.removeAll()
            searchBar.showsCancelButton = false
        } else {
            isSearchActive = true
            searchBar.showsCancelButton = true
            filteredMovies = movies.filter({ movie in
                movie.title.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearchActive = false
        filteredMovies.removeAll()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

//
//  CountriesView.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/18/24.
//

import UIKit
import Combine

class CountriesViewController: UITableViewController, UISearchResultsUpdating {
    
    let viewModel = CountryViewModel()
    var searchController: UISearchController!
    
    // Subscriptions to store Combine cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        setupBindings()
        
        Task {
            await viewModel.fetchCountries()
        }
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Capital or Name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupBindings() {
        // Bind the filteredCountries to the tableView
        viewModel.$filteredCountries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // If there are other properties in the ViewModel that might change
        // and should cause the tableView to reload, add them here as well.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CountryCell")
        
        let country = viewModel.filteredCountries[indexPath.row]
        cell.textLabel?.text = "\(country.name), \(country.region)"
        cell.detailTextLabel?.text = country.capital
        
        return cell
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            viewModel.search(for: searchText)
        } else {
            viewModel.resetSearch()
        }
    }
}



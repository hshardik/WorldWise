//
//  CountriesView.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/18/24.
//

import UIKit
import Combine
import VungleAdsSDK

class CountriesViewController: UITableViewController, UISearchResultsUpdating {
    
    let viewModel = CountryViewModel() // ViewModel for managing country data.
    var searchController: UISearchController! // Search controller for searching countries.
    private var bannerAdContainer: UIView! // Container view for displaying banner ads.
    private var bannerAd: VungleBanner? // Banner ad object from Vungle SDK.
    private var cancellables: Set<AnyCancellable> = [] // Set of Combine cancellables for managing subscriptions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic setup for the table view and search controller.
        setupTableView()
        setupSearchController()
        
        // Initialize the banner ad container.
        bannerAdContainer = UIView(frame: CGRect(x: Constants.RectSize.RectX, y: Constants.RectSize.RectY, width: Constants.RectSize.width, height: Constants.RectSize.height)) // Adjust height as needed.
        
        // Setup binding between ViewModel and the view.
        setupBindings()
        
        // Perform async operations to initialize SDK, load banner, and fetch countries.
        Task {
            await initializeSDKAndLoadBanner()
            await viewModel.fetchCountries()
            setupUI()
        }
    }
    
    private func setupUI() {
        // Additional setup for the UI elements, if needed.
        setupTableView()
        setupSearchController()
        setupBindings()
    }
    
    private func setupTableView() {
        // Register cells for the table view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
    }
    
    private func setupSearchController() {
        // Configure search controller properties.
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
        // Bind the filteredCountries from ViewModel to update the table view.
        viewModel.$filteredCountries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Define number of sections in the table view.
        1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Return the banner ad container as a header view for the table view.
        return bannerAdContainer
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Set the height for the header view.
        return 50 // Adjust height as needed.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of countries to be displayed in the table view.
        viewModel.filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure the cell for each country.
        var cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CountryCell")
        
        // Set up the cell with country data.
        let country = viewModel.filteredCountries[indexPath.row]
        cell.textLabel?.text = "\(country.name), \(country.region)"
        cell.detailTextLabel?.text = country.capital
        
        return cell
    }
    
    // Async method to initialize SDK and load banner
    private func initializeSDKAndLoadBanner() async {
        // Await the initialization of Vungle SDK.
        await withCheckedContinuation { continuation in
            VungleAds.initWithAppId(Constants.Vungle.appID) { error in
                if let error = error {
                    print("Error initializing Vungle SDK: \(error)")
                    continuation.resume()
                } else {
                    print("Vungle SDK Initialized Successfully")
                    continuation.resume()
                }
            }
        }
        
        // Load the banner ad if SDK is initialized.
        if VungleAds.isInitialized() {
            await withCheckedContinuation { continuation in
                let bannerAd = VungleBanner(placementId: Constants.Vungle.Placements.banner, size: .regular)
                bannerAd.delegate = self
                bannerAd.load()
                self.bannerAd = bannerAd
                continuation.resume()
            }
        }
    }
    
    deinit {
        // Clean up the VungleBanner instance when the view controller is deinitialized.
        for subView in bannerAdContainer.subviews {
            subView.removeFromSuperview()
        }
        bannerAd?.delegate = nil
        bannerAd = nil
        print("CountriesViewController is being deinitialized")
    }
}

// MARK: - UISearchResultsUpdating

extension CountriesViewController {
    func updateSearchResults(for searchController: UISearchController) {
        // Handle search results updates.
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            viewModel.search(for: searchText)
        } else {
            viewModel.resetSearch()
        }
    }
}

// MARK: Vungle SDK Banner Delegate Callbacks
extension CountriesViewController: VungleBannerDelegate {
    @MainActor
    func bannerAdDidLoad(_ banner: VungleBanner) {
        // Handle banner ad load event.
        print("bannerAdDidLoad")
        self.bannerAd?.present(on: self.bannerAdContainer)
    }
    
    func bannerAdDidFailToLoad(_ banner: VungleBanner, withError: NSError) {
        // Handle banner ad load failure event.
        print("bannerAdDidFailToLoad: \(withError)")
    }
}

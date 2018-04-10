//
//  SearchViewController.swift
//  OpenWeatherAPI
//
//  Created by 박수현 on 10/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicate: UIActivityIndicatorView!
    
    var searchController: UISearchController?
    var dataSourceOrigin: [WeatherInfo]? = []
    var searchStrArr: [String] = []
    var dataSource: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        
        indicate.startAnimating()
        DispatchQueue.main.async {
            WeatherDataManager.shread.loadJsonData()
            self.dataSourceOrigin = WeatherDataManager.shread.searchJsonData
            
            for item in self.dataSourceOrigin! {
                self.searchStrArr.append(item.locationWeather.country)
            }
            
            self.indicate.hidesWhenStopped = true
            self.indicate.stopAnimating()
            print(self.dataSourceOrigin?.count)
            self.tableView.reloadData()
        }
    }
    
    func setNavigationItem() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.largeTitleDisplayMode = .always
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        searchController?.searchResultsUpdater = self
        
        // 즉시 상호작용?
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search City"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController?.isActive == false {
            return 0
        }else {
            return dataSource?.count ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if searchController?.isActive == false {
            return cell
            
        }else {
            cell.textLabel?.text = dataSource![indexPath.row]
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellText = cell?.textLabel?.text as! String
        let idx = searchStrArr.index(of: "\(cellText)")
        
        let lon = dataSourceOrigin![idx!].coord!["lon"]
        let lat = dataSourceOrigin![idx!].coord!["lat"]
        
        WeatherDataManager.shread.setChoiceWeather(lati: lat!, longi: lon!) { (ok, resultdata, error) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        if searchBar.text != nil && searchBar.text!.count > 0 {
            
            let item = DispatchWorkItem {[unowned self] in
                DispatchQueue.main.async {
                    self.dataSource = self.searchStrArr.filter({ [unowned self] in
                        $0.contains(searchBar.text as! String)
                    })
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.global().async(execute: item)
        }else {
            dataSource?.removeAll()
            dataSource! += searchStrArr
        }
        tableView.reloadData()
    }
}

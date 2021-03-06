//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Karen Rodriguez on 3/10/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var limitToUs: UISwitch!
    @IBOutlet weak var numberLimit: UITextField!
    
    let searchResultsController = SearchResultController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultsController.searchResults.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = searchResultsController.searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResultsController.searchResults[indexPath.row].creator
        
        

        return cell
    }
    
    @IBAction func changeSegmentTapped(_ sender: UISegmentedControl) {
        search()
    }
    
    func search() {
        guard let searchTerm = searchBar.text else { return }
        
        let resultType: ResultType
        switch segmentControl.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            fatalError("Literally how?")
        }
        
        
        
        searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType, limitByUS: limitToUs.isOn, searchLimit: Int(numberLimit!.text!)) { (error) in
            
            if let error = error {
                print("error here: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("Reloaded")
                print(self.searchResultsController.searchResults)
            }
        }
    }
}


extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       search()
    }
}

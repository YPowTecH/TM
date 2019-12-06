//
//  ViewController.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel = ViewModel() {
        didSet {
            if let _ = viewModel.error {
                self.showAlert("oops")
            }
            else if viewModel.gUsers.isEmpty {
                self.showAlert("no data")
            }
            else {
                self.mainTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        //----------------------------
        //Search Bar
        //----------------------------
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //navigationItem.hidesSearchBarWhenScrolling = false
        //navigationItem.searchController = searchController
        definesPresentationContext = true
        //----------------------------
        
        //----------------------------
        //Register Cells for Table
        //----------------------------
        mainTableView.register(UINib(nibName: MainTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: MainTableCell.identifier)
        //----------------------------
        
        //----------------------------
        //Table Styling
        //----------------------------
        mainTableView.tableFooterView = UIView(frame: .zero)
        //----------------------------
        
        //----------------------------
        //Notification & Delegates
        //----------------------------
        viewModel.mainDelegate = self
        //----------------------------
        
        //----------------------------
        //Refresh Button
        //----------------------------
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "refresh"), for: .bookmark, state: .normal)
        //----------------------------
        
        //----------------------------
        //Navigation Bar
        //----------------------------
        navigationItem.titleView = searchController.searchBar
        //----------------------------
    }
    
    //get an updated api call on refresh button click
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        viewModel.getSearch(viewModel.searchTerm ?? "", refresh: true)
    }
}

//----------------------------
//Search Bar Extension
//----------------------------
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchController.searchBar.text
        
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        viewModel.searchTerm = searchText
        
        if !viewModel.isSameSearch() {
            //mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.getSearch(searchText)
    }
    
    //Send a query everytime we hit a button
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
     mainTableView.setContentOffset(.zero, animated: false)
     viewModel.getSearch(searchText)
     viewModel.searchTerm = searchText
     }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTerm = ""
        viewModel.getSearch()
    }
}
//----------------------------

//----------------------------
//Table View Extension
//----------------------------
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableCell.identifier, for: indexPath) as! MainTableCell
        
        let user = viewModel.gUsers[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //viewModel.isBottom(scrollView)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //TODO:Show/goto Details Page
        //viewModel.currentArticle = indexPath.row
        //goToDetail(with: viewModel)
    }
}
//----------------------------

//TODO: Fix Alert repulls
//----------------------------
//Custom Error Alert extension
//----------------------------
extension MainViewController {
    //If the view receives an error message we have to display that
    //  to the user in a useful way
    //  they can either retry the connection or cancel the opperation
    func showAlert(_ message: String) {
        //take the message that was passed to the function
        //  and use that as the text for the error
        let alert = UIAlertController(title: message, message: nil,
                                      preferredStyle: .alert)
        //retry button to attempt another get request from the url
        let retry = UIAlertAction(title: "RETRY", style: .default) { (_) in
            //self.viewModel.getCharacters()
        }
        
        //cancel button to stop trying to get the data for another 2 seconds
        //  should be longer probably but for testing purposes its 2 seconds
        let cancel = UIAlertAction(title: "CANCEL", style: .default) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                //self.viewModel.getCharacters()
            })
        }
        
        //add both the buttons to the alert
        alert.addAction(retry)
        alert.addAction(cancel)
        
        //show the alert
        self.present(alert, animated: true)
    }
}

//----------------------------
//Property observers delegates
//----------------------------
extension MainViewController: MainDelegate {
    func mainUpdate() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}
//----------------------------

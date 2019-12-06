//
//  RepoSearchTableCell.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/6/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

protocol RepoSearchViewDelegate {
    func textDidChange(searchText: String)
}

class RepoSearchTableCell: UITableViewCell {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: RepoSearchViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self
    }

    static let identifier = "RepoSearchTableCell"
}

extension RepoSearchTableCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let delegate = delegate, searchText.isEmpty == false {
            delegate.textDidChange(searchText: searchText)
        }
    }
}

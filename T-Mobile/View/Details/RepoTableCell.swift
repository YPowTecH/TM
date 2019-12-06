//
//  RepoTableCell.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/6/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class RepoTableCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    //Easy to reference identifier for use in other ViewControllers
    static let identifier = "RepoTableCell"
}

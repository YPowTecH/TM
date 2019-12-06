//
//  DetailsUserInfoTableCell.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/6/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class DetailsUserInfoTableCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    //Easy to reference identifier for use in other ViewControllers
    static let identifier = "DetailsUserInfoTableCell"
    
}

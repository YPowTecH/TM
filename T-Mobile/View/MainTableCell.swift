//
//  MainTableCell.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellUsername: UILabel!
    @IBOutlet weak var cellRepoCount: UILabel!
    
    
    //Easy to reference identifier for use in other ViewControllers
    static let identifier = "MainTableCell"
    
    var user: GitUser! {
        didSet {
            cellUsername.text = user.username
            
            if user.img != nil {
                user.getImg() { [weak self] img in
                    DispatchQueue.main.async {
                        self?.cellImg.image = img
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self.cellImg.image = UIImage(imageLiteralResourceName: "404s")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.cellImg.image = nil
    }
}

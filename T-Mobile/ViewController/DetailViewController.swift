//
//  DetailViewController.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    //Easy to reference identifier for use in other ViewControllers
    static let identifier = "DetailViewController"
    
    var viewModel: SingleGUserViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.detailTableView?.reloadData()
            }
            viewModel.bind {
                DispatchQueue.main.async { [weak self] in
                    // self?.detailTableView.reloadSections([2], with: .automatic)
                    self?.detailTableView.reloadData()
                }
            }
        }
    }
    var throttle: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        //----------------------------
        //Register Cells for Table
        //----------------------------
        detailTableView.register(UINib(nibName: DetailsUserInfoTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: DetailsUserInfoTableCell.identifier)
        detailTableView.register(UINib(nibName: RepoSearchTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: RepoSearchTableCell.identifier)
        detailTableView.register(UINib(nibName: RepoTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: RepoTableCell.identifier)
        //----------------------------
        
    }
    
    // if user presses enter
    func search(_ query: String) {
        if let throttle = throttle {
            throttle.cancel()
        }
        throttle = DispatchWorkItem(block: {
            self.viewModel.searchRepos(query)
        })
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.35,
                                          execute: throttle!)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsUserInfoTableCell.identifier,
                                                     for: indexPath) as! DetailsUserInfoTableCell
            let user = viewModel.user
            cell.usernameLabel.text = user.username
            cell.emailLabel.text = "Email: " + (user.info?.email ?? "n/a")
            cell.locationLabel.text = "Location: " + (user.info?.location ?? "n/a")
            cell.joinDateLabel.text = "Join Date: " + (user.info?.joinDate ?? "n/a")
            cell.followersLabel.text = String(user.info?.followers ?? 0) + " Followers"
            cell.followingLabel.text = "Following " + String(user.info?.following ?? 0)
            cell.biographyLabel.text = user.info?.bio
            if user.img != nil {
                user.getImg() { img in
                    DispatchQueue.main.async {
                        cell.avatarImageView?.image = img
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    cell.avatarImageView?.image = UIImage(imageLiteralResourceName: "404s")
                }
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepoSearchTableCell.identifier,
                                                     for: indexPath) as! RepoSearchTableCell
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableCell.identifier,
                                                 for: indexPath) as! RepoTableCell
        let repo = viewModel.currRepos[indexPath.row]
        cell.repoNameLabel.text = repo.name
        cell.forksCountLabel.text = String(repo.forks) + " Forks"
        cell.starsCountLabel.text = String(repo.stars) + " Stars"
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        }
        return viewModel.currRepos.count
    }
}

extension DetailViewController: UITableViewDelegate {
}

extension DetailViewController: RepoSearchViewDelegate {
    func textDidChange(searchText: String) {
        search(searchText)
    }
}

extension DetailViewController: DetailDelegate {
    func detailUpdate(_ viewModel: SingleGUserViewModel) {
        self.viewModel = viewModel
    }
}

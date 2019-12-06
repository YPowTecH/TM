//
//  SingleGUserViewModel.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/6/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

class SingleGUserViewModel {
    
    let user: GitUser
    var currRepos: [GitRepo] = [] {
        didSet {
            update?()
        }
    }
    var update: (()->Void)?
    
    init(_ user: GitUser) {
        self.user = user
    }
    
    func bind(_ update: @escaping ()->Void) {
        self.update = update
    }
    
    func bindAndFire(_ update: @escaping ()->Void) {
        self.update = update
        update()
    }

    func searchRepos(_ search: String) {
        gService.getGitRepos(user: user.username, search: search) { (response) in
            switch response {
            case .error(let _):
                    // do something with error
                fallthrough
            case .empty:
                self.currRepos = []
            case .valid(let r):
                self.currRepos = r
            }
        }
    }
    
}

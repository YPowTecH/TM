//
//  GitAPI.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

struct GitAPI {
    
    private let BASE = "https://api.github.com/"
    private let LIMIT = 20
    
    /*
        https://api.github.com/
        search/users
        ?q=
        &page=
        &limit=
    */
    func getGitUsers(q: String, page: Int) -> URL? {
        let search = "search/users"
        let kQ = "?q=" + q
        let kPage = "&page=" + String(page)
        let kLimit = "&limit=" + String(LIMIT)
        
        return URL(string: BASE + search + kQ + kPage + kLimit)
    }
    
    /*
        https://api.github.com/
        users/
        /repos
     */
    func getGitRepos(user: String) -> URL? {
        let kUser = "users/" + user
        let kRepo = "/repos"
        
        return URL(string: BASE + kUser + kRepo)
    }
}

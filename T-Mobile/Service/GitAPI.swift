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
    */
    func getGitUser(user: String) -> URL? {
        let kUser = "users/" + user
        
        return URL(string: BASE + kUser)
    }
    
    
    /*
        https://api.github.com/
        search/
        /responsitories
        ?=
        +user:
    */
    // https://api.github.com/search/repositories?q=ccc+user:YPowTecH
    func getGitRepos(user: String, search: String) -> URL? {
        let query = "search/repositories?q=" + search
        let user = "+user:" + user
        return URL(string: BASE + query + user)
    }
}

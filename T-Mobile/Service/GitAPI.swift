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
        users/
        /repos
        ?per_page=
    */
    func getGitRepos(user: String, limit: Int = 0) -> URL? {
        let kUser = "users/" + user
        let kRepo = "/repos"
        var kLimit = "?per_page="
        
        //for getting repo count
        if limit > 0 {
            kLimit += String(limit)
        }
        //for getting actual repos
        else {
            kLimit += String(LIMIT)
        }
        
        return URL(string: BASE + kUser + kRepo + kLimit)
    }
}

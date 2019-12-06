//
//  GUsersViewModel.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

protocol MainDelegate: class {
    func mainUpdate()
}

protocol DetailDelegate: class {
    func detailUpdate(_ viewModel: SingleGUserViewModel)
}

class GUsersViewModel {

    weak var mainDelegate: MainDelegate?
    weak var detailDelegate: DetailDelegate?
    
    var searchTerm: String? = ""
    
    var gUsers = [GitUser]() {
        didSet {
            mainDelegate?.mainUpdate()
        }
    }
    
    var currentGUser: GitUser?
    
    //for inf scrolling need to know how many users
    //  we can scroll through before we hit the end
    var totalGitUsers: Int = 0
    
    var bottomOfList: Bool = false
    
    var error: Error?
    
    private var pastSearch: String? = nil
    private var sameSearch: Bool = false
    
    //TODO: if search term is "" just clear the list
    func getSearch(_ search: String = "", refresh: Bool = false) {
        if isSameSearch() && !bottomOfList && !refresh {
            return
        }
        
        if searchTerm == "" {
            gUsers = []
            totalGitUsers = 0
            return
        }
        
        if !bottomOfList {
            getSearchResults(search: search)
        }
        else if bottomOfList {
            let p = ((gUsers.count / 20) + 1)
            getSearchResults(search: search, page: p, addon: true)
        }
    }
    
    func getMore() {
        guard let searchTerm = searchTerm else { return }
        let p = ((gUsers.count / 20) + 1)
        getSearchResults(search: searchTerm, page: p, addon: true)
    }
    
    //helper function to utilize our specalized searching needs
    private func getSearchResults(search: String, page: Int = 1, addon: Bool = false) {
        gService.getGitUsers(search: search, page: page) { [weak self] response in
            self?.setupGitUsersArr(response: response, addon: addon)
        }
    }
    
    //Helper function to manage the array better with inf scrolling
    private func setupGitUsersArr(response: GitUsersResponse, addon: Bool) {
        switch response {
        case .valid(let results):
            if addon {
                gUsers.append(contentsOf: results.result)
            }
            else {
                gUsers = results.result
                totalGitUsers = results.totalResults
            }
        case .error(let err):
            error = err
            fallthrough
        case .empty:
            if !addon {
                gUsers = []
            }
        }
    }
    
    //TODO: Check if we are at the bottom of the page to get more info
    func isBottom() {
        if totalGitUsers > gUsers.count {
            
        }
    }
    
    //Check if we have the same search word
    //  mainly used to prevent double
    //  searching the same word
    func isSameSearch() -> Bool {
        return searchTerm == pastSearch
    }
}

//
//  GitService.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum GitUsersResponse {
    case valid(GitUserResults)
    case empty
    case error(Error)
}

enum GitReposResponse {
    case valid([GitRepo])
    case empty
    case error(Error)
}

typealias GitUsersHandler = (GitUsersResponse) -> Void
typealias GitReposHandler = (GitReposResponse) -> Void

let gService = GitService.shared

//Git Service
final class GitService {
    static let shared = GitService()
    private init() {}
    
    //-------------------
    //Get [git users] Data
    //-------------------
    func getGitUsers(search: String,
                     page: Int,
                     completion: @escaping GitUsersHandler) {
        guard let url = GitAPI().getGitUsers(q: search, page: page) else {
            completion(.empty)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            //shouldn't have any bad urls
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(.error(error))
                return
            }
            
            if let data = dat {
                do {
                    let gitUserResults = try JSONDecoder().decode(GitUserResults.self, from: data)
                    completion(.valid(gitUserResults))
                } catch let myError {
                    print("Couldn't Decode JSON: \(myError.localizedDescription)")
                    completion(.error(myError))
                    return
                }
            }
        }.resume()
    }
    
    //-------------------
    //Get [git user's repos] Data
    //-------------------
    func getGitRepos(search: String,
                     completion: @escaping GitReposHandler) {
        guard let url = GitAPI().getGitRepos(user: search) else {
            completion(.empty)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            //shouldn't have any bad urls
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(.error(error))
                return
            }
            
            if let data = dat {
                do {
                    let gitRepos = try JSONDecoder().decode([GitRepo].self, from: data)
                    completion(.valid(gitRepos))
                } catch let myError {
                    print("Couldn't Decode JSON: \(myError.localizedDescription)")
                    completion(.error(myError))
                    return
                }
            }
        }.resume()
    }
}

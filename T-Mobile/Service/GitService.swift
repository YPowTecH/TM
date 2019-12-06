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
typealias GitRepoInfo = (GitUserInfo?) -> Void
typealias GitReposHandler = (GitReposResponse) -> Void

let gService = GitService.shared

//Git Service
final class GitService {
    static let shared = GitService()
    
    var requestsInProgress = Set<String>()
    var fetchMore: Bool = false
    
    private init() {}
    
    //-------------------
    //Get [git users] Data
    //-------------------
    func getGitUsers(search: String,
                     page: Int,
                     completion: @escaping GitUsersHandler) {
        if fetchMore == true { return }
        fetchMore = true
        guard let url = GitAPI().getGitUsers(q: search, page: page) else {
            completion(.empty)
            fetchMore = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            defer { self.fetchMore = false }
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
    //Get [git user's repo count] Data
    //-------------------
    func getUserInformation(user: String,
                         completion: @escaping GitRepoInfo) {
        // if we are already doing this request, don't process another one.
        if requestsInProgress.contains(user) {
            return
        }
        guard let url = GitAPI().getGitUser(user: user) else {
            completion(nil)
            return
        }
        
        print(url)
        requestsInProgress.insert(user)
        URLSession.shared.dataTask(with: url) { (dat, resp, err) in
            defer {
                self.requestsInProgress.remove(user)
            }
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let dat = dat {
                let info = try! JSONDecoder().decode(GitUserInfo.self, from: dat)
                print("success")
                completion(info)
            }
        }.resume()
    }
    
    
    //-------------------
    //Get [git user's repos] Data
    //-------------------
    /*
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
    }*/
    
    //-------------------
    //Get [git user's repos] Data
    //-------------------
    func getGitRepos(user: String, search: String, completion: @escaping GitReposHandler) {
        guard let url = GitAPI().getGitRepos(user: user, search: search) else {
            completion(.empty)
            return
        }
        
        //shouldn't have any bad urls
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(.error(error))
                return
            }
      
            if let data = dat {
                do {
                    let gitRepos = try JSONDecoder().decode(GitRepoResult.self, from: data)
                    completion(.valid(gitRepos.items))
                } catch let myError {
                    print("Couldn't Decode JSON: \(myError.localizedDescription)")
                    completion(.error(myError))
                    return
                }
            }
        }.resume()
    }
}


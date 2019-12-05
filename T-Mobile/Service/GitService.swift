//
//  GitService.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum GitUsersResponse {
    case valid([GitUser])
    case empty
    case error(Error)
}

typealias GitUsersHandler = (GitUsersResponse) -> Void

let GS = GitService.shared

//Git Service
final class GitService {
    static let shared = GitService()
    private init() {}
    
    //-------------------
    //Get Data
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
                    let gitUsers = try JSONDecoder().decode(GitResponse.self, from: data)
                    completion(.valid(gitUsers.result))
                } catch let myError {
                    print("Couldn't Decode JSON: \(myError.localizedDescription)")
                    completion(.error(myError))
                    return
                }
            }
        }.resume()
    }
}

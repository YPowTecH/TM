//
//  GitUsers.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

struct GitUserResults: Decodable {
    var result: [GitUser]
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case result = "items"
        case totalResults = "total_count"
    }
}

class GitUser: Decodable {
    let username: String
    let img: String?
    let followers: Int?
    let following: Int?
    let bio: String?
    let email: String?
    let location: String?
    let joinDate: String?
    let repos: [GitRepo]?
    
    init(name: String) {
        self.username = name
        img = nil
        followers = nil
        following = nil
        bio = nil
        email = nil
        location = nil
        joinDate = nil
        repos = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case img = "avatar_url"
        case joinDate = "created_at"
        case followers, following, bio, email, location, repos
    }

    func getImg(completion: @escaping (UIImage?) -> Void) {
        guard let img = self.img else { return }
        
        cache.downloadFrom(endpoint: img) { response in
            switch response {
            case .valid(let dat):
                completion(UIImage(data: dat))
            case .error(_):
                completion(UIImage(imageLiteralResourceName: "404s"))
            case .empty:
                completion(UIImage(imageLiteralResourceName: "404s"))
            }
        }
    }
    
    func getRepoCount(completion: @escaping (Int?) -> Void) {
        gService.getGitRepoCount(user: username) { response in
            completion(response)
        }
    }
}

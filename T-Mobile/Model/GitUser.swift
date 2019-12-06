//
//  GitUsers.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

struct GitResponse: Decodable {
    let result: [GitUser]
    
    private enum CodingKeys: String, CodingKey {
        case result = "items"
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
    
    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case img = "avatar_url"
        case joinDate = "created_at"
        case followers, following, bio, email, location, repos
    }
    
    //TODO: get repo count
    //TODO: get image
}

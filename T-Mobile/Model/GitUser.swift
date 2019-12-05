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
    let img: String
    
    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case img = "avatar_url"
    }
    
    //TODO: get repo count
}

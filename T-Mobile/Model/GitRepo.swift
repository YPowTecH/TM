//
//  GitRepo.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

class GitRepo: Decodable {
    let name: String
    let forks: Int
    let stars: Int
    
    private enum CodingKeys: String, CodingKey {
        case forks = "forks_count"
        case stars = "stargazers_count"
        case name
    }
}

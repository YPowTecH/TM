//
//  GitRepoResult.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/6/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

struct GitRepoResult: Decodable {
    let items: [GitRepo]
}

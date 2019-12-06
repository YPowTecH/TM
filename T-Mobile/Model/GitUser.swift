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

struct Formatters {
    enum FormatterError: Error {
        case invalidDate
    }
    private static var makeDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return f
    }()
    private static var makeStringFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    static func makeDate(from string: String) -> Date? {
        return makeDateFormatter.date(from: string)
    }
    static func makeString(from date: Date) -> String {
        return makeStringFormatter.string(from: date)
    }
}

struct GitUserInfo: Decodable {
    let bio: String?
    let email: String?
    let followers: Int
    let following: Int
    let location: String?
    let joinDate: String
    var repoCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case bio, email, followers, following, location
        case repoCount = "public_repos"
        case joinDate = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        followers = try container.decode(Int.self, forKey: .followers)
        following = try container.decode(Int.self, forKey: .following)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        let joinDateStr = try container.decode(String.self, forKey: .joinDate)
        repoCount = try container.decode(Int.self, forKey: .repoCount)
        guard let date = Formatters.makeDate(from: joinDateStr) else {
            throw Formatters.FormatterError.invalidDate
        }
        joinDate = Formatters.makeString(from: date)
    }
}

class GitUser: Decodable {
    let username: String
    let img: String?
    var repos: [GitRepo] = []
    var info: GitUserInfo? = nil
    var repoCount: Int? {
        set {
            info?.repoCount = newValue ?? 0
        }
        get {
            return info?.repoCount
        }
    }
    
    //TODO: DElete later was for testing
    init(name: String) {
        self.username = name
        img = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case img = "avatar_url"
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
        if let rCount = self.repoCount {
            completion(rCount)
        }
        else {
            gService.getUserInformation(user: self.username) { response in
                self.info = response
                completion(self.repoCount ?? 0)
            }
        }
    }
}

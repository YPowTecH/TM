//
//  CacheManager.swift
//  T-Mobile
//
//  Created by Chris Sonet on 12/5/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum DataResponse {
    case valid(Data)
    case empty
    case error(Error)
}

typealias DataHandler = (DataResponse) -> Void

let cache = CacheManager.shared

final class CacheManager {
    private let cache = NSCache<NSString, NSData>()
    
    static let shared = CacheManager()
    private init() {}
    
    //check if the images we are looking up are in cache
    //  if they are already then dont bother downloading them
    //  otherwise we gotta go get them
    func downloadFrom(endpoint: String, completion: @escaping DataHandler) {
        //if the image is already stored in cache just use that one
        if let data = cache.object(forKey: endpoint as NSString) {
            completion(.valid(data as Data))
            return
        }
        
        //If the site screws up their urls
        //  we will catch it here
        guard let url = URL(string: endpoint) else {
            completion(.empty)
            return
        }
        
        //Again kinda up to site to keep their urls
        //  relavent and if they arent we will throw and error
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            //if we got a bad url
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(.error(error))
                return
            }
            
            if let data = dat {
                //fetch the image and save it in cache for later use
                self.cache.setObject(data as NSData, forKey: endpoint as NSString)
                
                //return the image data to which ever function
                DispatchQueue.main.async {
                    completion(.valid(data))
                }
            }
        }.resume()
    }
}

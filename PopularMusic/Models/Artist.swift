//
//  Artist.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import Foundation

struct Artist: Codable {
    var name: String?
    var numberOfListeners: String?
    var images: [Images]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case numberOfListeners = "listeners"
        case images = "image"
    }
    
    struct Images: Codable {
        var url: String?
        var size: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "#text"
            case size = "size"
        }
    }
}

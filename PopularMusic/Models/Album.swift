//
//  Album.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import Foundation

struct Album: Codable {
    var name: String?
    var playcount: Int?
    var images: [Images]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case playcount = "playcount"
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

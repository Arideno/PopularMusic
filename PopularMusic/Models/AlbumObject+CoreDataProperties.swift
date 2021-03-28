//
//  AlbumObject+CoreDataProperties.swift
//  
//
//  Created by  Andrii Moisol on 28.03.2021.
//
//

import Foundation
import CoreData


extension AlbumObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumObject> {
        return NSFetchRequest<AlbumObject>(entityName: "AlbumObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var playcount: Int32
    @NSManaged public var artist: ArtistObject?
    
    func toAlbum() -> Album {
        return Album(name: name, playcount: Int(playcount), images: [Album.Images(url: imageUrl, size: "large")])
    }

}

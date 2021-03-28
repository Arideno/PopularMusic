//
//  ArtistObject+CoreDataProperties.swift
//  
//
//  Created by  Andrii Moisol on 28.03.2021.
//
//

import Foundation
import CoreData


extension ArtistObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistObject> {
        return NSFetchRequest<ArtistObject>(entityName: "ArtistObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var numberOfListeners: Int32
    @NSManaged public var country: String?
    
    func toArtist() -> Artist {
        return Artist(name: name, numberOfListeners: String(numberOfListeners), images: [Artist.Images(url: imageUrl, size: "medium")])
    }

}

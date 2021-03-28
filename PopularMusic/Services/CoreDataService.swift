//
//  CoreDataService.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 28.03.2021.
//

import Foundation
import CoreData
import RxSwift

class CoreDataService {
    static let `default` = CoreDataService()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PopularMusic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveArtists(_ artists: [Artist], for country: String) {
        artists.forEach { (artist) in
            let request: NSFetchRequest<ArtistObject> = ArtistObject.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", artist.name ?? "")
            
            guard let result = try? context.fetch(request), result.count > 0 else {
                let artistObject = ArtistObject(context: context)
                artistObject.name = artist.name
                artistObject.imageUrl = artist.images?.first(where: { $0.size == "medium" })?.url
                artistObject.numberOfListeners = Int32(artist.numberOfListeners ?? "0") ?? 0
                artistObject.country = country
                return
            }
        }
        
        saveContext()
    }
    
    func saveAlbums(_ albums: [Album], artist: Artist) {
        let artistRequest: NSFetchRequest<ArtistObject> = ArtistObject.fetchRequest()
        artistRequest.predicate = NSPredicate(format: "name == %@", artist.name ?? "")
        
        guard let result = try? context.fetch(artistRequest), let artistObject = result.first else { return }
        
        albums.forEach { (album) in
            let request: NSFetchRequest<AlbumObject> = AlbumObject.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@ AND artist.name == %@", album.name ?? "", artist.name ?? "")
            
            guard let result = try? context.fetch(request), result.count > 0 else {
                let albumObject = AlbumObject(context: context)
                albumObject.name = album.name
                albumObject.imageUrl = album.images?.first(where: { $0.size == "large" })?.url
                albumObject.playcount = Int32(album.playcount ?? 0)
                albumObject.artist = artistObject
                return
            }
        }
        
        saveContext()
    }
    
    func getAllArtists(for country: String) -> Observable<[Artist]> {
        let request: NSFetchRequest<ArtistObject> = ArtistObject.fetchRequest()
        request.predicate = NSPredicate(format: "country == %@", country)
        
        if let result = try? context.fetch(request) {
            return .just(result.map({ $0.toArtist() }).sorted(by: { $0.name ?? "" < $1.name ?? "" }))
        }
        
        return .just([])
    }
    
    func getAllAlbums(for artist: Artist) -> Observable<[Album]> {
        let request: NSFetchRequest<AlbumObject> = AlbumObject.fetchRequest()
        request.predicate = NSPredicate(format: "artist.name == %@", artist.name ?? "")
        
        if let result = try? context.fetch(request) {
            return .just(result.map({ $0.toAlbum() }))
        }
        
        return .just([])
    }
}

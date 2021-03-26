//
//  NetworkingService.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift
import Alamofire
import RxAlamofire

struct PopularArtistsResponse: Codable {
    var topartists: TopArtists?
    
    struct TopArtists: Codable {
        var artist: [Artist]?
    }
}

class NetworkingService {
    let baseURL = "http://ws.audioscrobbler.com/2.0/"
    let apiKey = "e81f61890b7ff8633ca024d0faa449e7"
    static let `default` = NetworkingService()
    
    func getPopularArtists(for country: String) -> Observable<[Artist]> {
        guard let url = URL(string: baseURL) else { return .just([]) }
        
        var parameters = [String: Any]()
        parameters["method"] = "geo.gettopartists"
        parameters["country"] = country
        parameters["api_key"] = apiKey
        parameters["format"] = "json"
        
        return RxAlamofire.requestData(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .flatMap { (_, data) -> Observable<[Artist]> in
                guard let topArtists = try? JSONDecoder().decode(PopularArtistsResponse.self, from: data) else { return .just([]) }
                guard let artists = topArtists.topartists?.artist else { return .just([]) }
                return .just(artists)
            }
    }
}

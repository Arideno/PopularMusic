//
//  ArtistInfoViewModel.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import RxSwift
import RxRelay

protocol ArtistInfoViewModelType: class {
    var input: ArtistInfoViewModel.Input! { get }
    var output: ArtistInfoViewModel.Output! { get }
}

class ArtistInfoViewModel: BaseViewModel, ArtistInfoViewModelType {
    var input: Input!
    var output: Output!
    var coordinatorInput: CoordinatorInput!
    
    private let closeSubject = PublishSubject<Void>()
    private let artistRelay = BehaviorRelay<Artist?>(value: nil)
    
    struct Input {
        
    }
    
    struct Output {
        var artist: Observable<Artist?>
    }
    
    struct CoordinatorInput {
        var close: Observable<Void>
    }
    
    init(coordinator: BaseCoordinatorType, artist: Artist) {
        super.init(coordinator: coordinator)
        
        setupIO()
        setupSubjects(artist: artist)
    }
    
    private func setupIO() {
        input = Input()
        output = Output(artist: artistRelay.asObservable())
        coordinatorInput = CoordinatorInput(close: closeSubject)
    }
    
    private func setupSubjects(artist: Artist) {
        artistRelay.accept(artist)
    }
}

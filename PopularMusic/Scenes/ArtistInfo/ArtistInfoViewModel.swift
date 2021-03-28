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
    private let cellsRelay = BehaviorRelay<[TopAlbumsSection]>(value: [])
    private let requestCellsSubject = PublishSubject<Void>()
    private let startLoadingSubject = PublishSubject<Void>()
    private var offlineRelay: BehaviorRelay<Bool>!
    
    struct Input {
        var requestCells: AnyObserver<Void>
    }
    
    struct Output {
        var artist: Observable<Artist?>
        var albums: BehaviorRelay<[TopAlbumsSection]>
        var startLoading: Observable<Void>
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
        let isOffline = UserDefaults.standard.bool(forKey: "offline")
        offlineRelay = BehaviorRelay<Bool>(value: isOffline)
        input = Input(requestCells: requestCellsSubject.asObserver())
        output = Output(artist: artistRelay.asObservable(), albums: cellsRelay, startLoading: startLoadingSubject)
        coordinatorInput = CoordinatorInput(close: closeSubject)
    }
    
    private func setupSubjects(artist: Artist) {
        artistRelay.accept(artist)
        
        requestCellsSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self, let artist = self.artistRelay.value else { return }
                self.startLoadingSubject.onNext(())
                self.cellsRelay.accept([])
                if self.offlineRelay.value {
                    CoreDataService.default.getAllAlbums(for: artist)
                        .flatMap { albums -> Observable<[TopAlbumsSection]> in
                            .just([TopAlbumsSection(items: albums)])
                        }
                        .bind(to: self.cellsRelay)
                        .disposed(by: self.disposeBag)
                } else {
                    NetworkingService.default.getTopAlbums(for: artist)
                        .flatMap { albums -> Observable<[TopAlbumsSection]> in
                            .just([TopAlbumsSection(items: albums)])
                        }
                        .bind(to: self.cellsRelay)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}

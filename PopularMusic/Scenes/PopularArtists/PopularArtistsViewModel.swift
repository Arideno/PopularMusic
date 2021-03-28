//
//  PopularArtistsViewModel.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift
import RxRelay
import RxAlamofire

protocol PopularArtistsViewModelType: class {
    var input: PopularArtistsViewModel.Input! { get }
    var output: PopularArtistsViewModel.Output! { get }
}

class PopularArtistsViewModel: BaseViewModel, PopularArtistsViewModelType {
    var input: Input!
    var output: Output!
    var coordinatorInput: CoordinatorInput!
    
    private let cellsRelay = BehaviorRelay<[PopularArtistsSection]>(value: [])
    private let requestCellsSubject = PublishSubject<Void>()
    private let selectCountrySubject = BehaviorRelay<String?>(value: nil)
    private let startLoadingSubject = PublishSubject<Void>()
    private let goToArtistInfoSubject = PublishSubject<Artist>()
    private var offlineRelay: BehaviorRelay<Bool>!
    
    struct Input {
        var requestCells: AnyObserver<Void>
        var selectCountry: BehaviorRelay<String?>
        var goToArtistInfo: AnyObserver<Artist>
        var offline: BehaviorRelay<Bool>
    }
    
    struct Output {
        var artists: Observable<[PopularArtistsSection]>
        var startLoading: Observable<Void>
    }
    
    struct CoordinatorInput {
        var goToArtistInfo: Observable<Artist>
    }
    
    override init(coordinator: BaseCoordinatorType) {
        super.init(coordinator: coordinator)
        
        setupIO()
        setupSubjects()
    }
    
    private func setupIO() {
        let isOffline = UserDefaults.standard.bool(forKey: "offline")
        offlineRelay = BehaviorRelay<Bool>(value: isOffline)
        input = Input(requestCells: requestCellsSubject.asObserver(), selectCountry: selectCountrySubject, goToArtistInfo: goToArtistInfoSubject.asObserver(), offline: offlineRelay)
        output = Output(artists: cellsRelay.asObservable(), startLoading: startLoadingSubject)
        coordinatorInput = CoordinatorInput(goToArtistInfo: goToArtistInfoSubject)
    }
    
    private func setupSubjects() {
        requestCellsSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self, let country = self.selectCountrySubject.value else { return }
                self.startLoadingSubject.onNext(())
                self.cellsRelay.accept([])
                if self.offlineRelay.value {
                    CoreDataService.default.getAllArtists(for: country)
                        .flatMap { artists -> Observable<[PopularArtistsSection]> in
                            .just([PopularArtistsSection(items: artists)])
                        }
                        .bind(to: self.cellsRelay)
                        .disposed(by: self.disposeBag)
                } else {
                    NetworkingService.default.getPopularArtists(for: country)
                        .flatMap { artists -> Observable<[PopularArtistsSection]> in
                            .just([PopularArtistsSection(items: artists)])
                        }
                        .bind(to: self.cellsRelay)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        selectCountrySubject
            .flatMap({ _ -> Observable<Void> in .just(()) })
            .bind(to: requestCellsSubject)
            .disposed(by: disposeBag)
        
        offlineRelay
            .do(onNext: { offline in
                UserDefaults.standard.set(offline, forKey: "offline")
            })
            .flatMap({ _ -> Observable<Void> in .just(()) })
            .bind(to: requestCellsSubject)
            .disposed(by: disposeBag)
    }
}

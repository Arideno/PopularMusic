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
    
    private let cellsRelay = BehaviorRelay<[PopularArtistsSection]>(value: [])
    private let requestCellsSubject = PublishSubject<Void>()
    
    struct Input {
        var requestCells: AnyObserver<Void>
    }
    
    struct Output {
        var artists: Observable<[PopularArtistsSection]>
    }
    
    override init(coordinator: BaseCoordinatorType) {
        super.init(coordinator: coordinator)
        
        setupIO()
        setupSubjects()
    }
    
    private func setupIO() {
        input = Input(requestCells: requestCellsSubject.asObserver())
        output = Output(artists: cellsRelay.asObservable())
    }
    
    private func setupSubjects() {
        requestCellsSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                NetworkingService.default.getPopularArtists(for: "israel")
                    .flatMap { artists -> Observable<[PopularArtistsSection]> in
                        .just([PopularArtistsSection(items: artists)])
                    }
                    .bind(to: self.cellsRelay)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

//
//  PopularArtistsCoordinator.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift

class PopularArtistsCoordinator: BaseCoordinator<Void> {
    private var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewController = PopularArtistsViewController()
        presentedViewController = viewController
        let viewModel = PopularArtistsViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        
        viewModel.coordinatorInput.goToArtistInfo
            .flatMap({ [weak self, weak viewController] artist -> Observable<Void> in
                guard let self = self, let viewController = viewController else { return .just(()) }
                return self.coordinate(to: ArtistInfoCoordinator(presentingViewController: viewController, artist: artist))
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return .never()
    }
}

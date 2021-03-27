//
//  ArtistInfoCoordinator.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import RxSwift

class ArtistInfoCoordinator: BaseCoordinator<Void> {
    private var presentingViewController: UIViewController
    private var artist: Artist
    
    init(presentingViewController: UIViewController, artist: Artist) {
        self.presentingViewController = presentingViewController
        self.artist = artist
    }
    
    override func start() -> Observable<Void> {
        let viewController = ArtistInfoViewController()
        presentedViewController = viewController
        let viewModel = ArtistInfoViewModel(coordinator: self, artist: artist)
        viewController.viewModel = viewModel
        
        presentingViewController.navigationController?.pushViewController(viewController, animated: true)
        
        return viewModel.coordinatorInput.close
            .do(onNext: { [weak viewController] in
                viewController?.dismiss(animated: true, completion: nil)
            })
    }
}

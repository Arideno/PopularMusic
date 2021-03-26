//
//  AfterSplashCoordinator.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift

class AfterSplashCoordinator: BaseCoordinator<Void> {
    private var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewController = AfterSplashViewController()
        presentedViewController = viewController
        let viewModel = AfterSplashViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return .never()
    }
}

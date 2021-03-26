//
//  AppCoordinator.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let afterSplashCoordinator = AfterSplashCoordinator(window: window)
        return coordinate(to: afterSplashCoordinator)
    }
    
}

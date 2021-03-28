//
//  AppDelegate.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import Reachability
import RxSwift
import RxReachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    var reachability: Reachability?
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        reachability = try? Reachability()
        try? reachability?.startNotifier()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start().subscribe().disposed(by: disposeBag)
        
        Reachability.rx.isReachable
            .subscribe(onNext: { isReachable in
                UserDefaults.standard.set(!isReachable, forKey: "offline")
            })
            .disposed(by: disposeBag)
        
        return true
    }

}


//
//  BaseCoordinator.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import RxSwift

protocol BaseCoordinatorType: class {
    var presentedViewController: UIViewController? { get set }
    var disposeBag: DisposeBag { get }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T>
}

class BaseCoordinator<ResultType>: BaseCoordinatorType {
    typealias CoordinationResult = ResultType
    
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    
    private var childCoordinators = [UUID: Any]()
    
    var presentedViewController: UIViewController?
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

//
//  BaseViewModel.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import RxSwift

class BaseViewModel {
    let coordinator: BaseCoordinatorType
    let disposeBag = DisposeBag()
    
    init(coordinator: BaseCoordinatorType) {
        self.coordinator = coordinator
    }
}

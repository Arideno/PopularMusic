//
//  BaseViewController.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import RxSwift

protocol BaseViewControllerType: class {
    associatedtype ViewModel
    
    var disposeBag: DisposeBag { get }
    var viewModel: ViewModel! { get }
}

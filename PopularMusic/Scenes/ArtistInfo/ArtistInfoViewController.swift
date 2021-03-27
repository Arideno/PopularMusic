//
//  ArtistInfoViewController.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import UIKit
import RxSwift

class ArtistInfoViewController: UIViewController, BaseViewControllerType {
    typealias ViewModel = ArtistInfoViewModelType
    
    let disposeBag = DisposeBag()
    var viewModel: ArtistInfoViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.output.artist
            .subscribe(onNext: { [weak self] artist in
                guard let self = self, let artist = artist else { return }
                self.title = artist.name
            })
            .disposed(by: disposeBag)
    }
    
}

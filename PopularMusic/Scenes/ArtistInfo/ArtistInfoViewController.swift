//
//  ArtistInfoViewController.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import UIKit
import RxSwift
import SnapKit

class ArtistInfoViewController: UIViewController, BaseViewControllerType {
    typealias ViewModel = ArtistInfoViewModelType
    
    let disposeBag = DisposeBag()
    var viewModel: ArtistInfoViewModelType!
    lazy var dataSource = ArtistInfoDataSource()
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupTableView()
        setupViewModel()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.register(TopAlbumTableViewCell.self, forCellReuseIdentifier: TopAlbumTableViewCell.identifier)
    }
    
    private func setupViewModel() {
        viewModel.output.artist
            .subscribe(onNext: { [weak self] artist in
                guard let self = self, let artist = artist else { return }
                self.title = artist.name
            })
            .disposed(by: disposeBag)
        
        viewModel.output.albums
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.input.requestCells.onNext(())
    }
    
}

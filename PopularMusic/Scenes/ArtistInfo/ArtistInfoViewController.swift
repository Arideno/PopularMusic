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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainColor]
        
        setupViews()
        setupTableView()
        setupViewModel()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
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
        
        viewModel.output.albums
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            })
            .disposed(by: disposeBag)
        
        viewModel.output.startLoading
            .subscribe(onNext: { [weak self] in
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.requestCells.onNext(())
    }
    
}

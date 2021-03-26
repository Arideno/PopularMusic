//
//  PopularArtistsViewController.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import RxSwift
import SnapKit
import RxDataSources

class PopularArtistsViewController: UIViewController, BaseViewControllerType {
    typealias ViewModel = PopularArtistsViewModelType
    
    let disposeBag = DisposeBag()
    var viewModel: PopularArtistsViewModelType!
    lazy var dataSource = PopularArtistsDataSource()
    
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
        
        title = "Popular Artists"
        
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
        
        activityIndicator.startAnimating()
    }
    
    private func setupTableView() {
        tableView.register(PopularArtistTableViewCell.self, forCellReuseIdentifier: PopularArtistTableViewCell.identifier)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        viewModel.output.artists
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.artists
            .filter({ $0.count > 0 })
            .filter({ $0.first!.items.count > 0 })
            .subscribe(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            })
            .disposed(by: disposeBag)
        
        viewModel.input.requestCells.onNext(())
    }
}

extension PopularArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

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
    
    let countries = ["Ukraine", "France", "Germany"]
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        return ai
    }()
    
    lazy var countryButtonItem: UIBarButtonItem = {
        let bbi = UIBarButtonItem()
        bbi.title = countries.first
        let actions = countries.map { (country) -> UIAction in
            return UIAction(title: country, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off) { _ in
                bbi.title = country
                self.viewModel.input.selectCountry.accept(country)
            }
        }
        bbi.menu = UIMenu(title: "Select Country", image: nil, identifier: nil, options: .displayInline, children: actions)
        return bbi
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
        
        navigationItem.rightBarButtonItem = countryButtonItem
    }
    
    private func setupTableView() {
        tableView.register(PopularArtistTableViewCell.self, forCellReuseIdentifier: PopularArtistTableViewCell.identifier)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .flatMap { [weak self] (indexPath) -> Observable<Artist> in
                guard let self = self else { return .empty() }
                self.tableView.deselectRow(at: indexPath, animated: true)
                return .just(self.dataSource[indexPath])
            }
            .bind(to: viewModel.input.goToArtistInfo)
            .disposed(by: disposeBag)
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
        
        viewModel.output.startLoading
            .subscribe(onNext: { [weak self] in
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.selectCountry.accept(countries.first)
    }
}

extension PopularArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

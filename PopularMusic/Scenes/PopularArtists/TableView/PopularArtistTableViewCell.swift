//
//  PopularArtistTableViewCell.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import RxSwift
import SnapKit
import RxAlamofire

class PopularArtistTableViewCell: UITableViewCell, ReuseIdentifiable {
    private let disposeBag = DisposeBag()
    
    let artistImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let listenersLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(artistImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(listenersLabel)
        
        artistImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(100).priority(999)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistImageView)
            make.leading.equalTo(artistImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        listenersLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    func fill(artist: Artist) {
        if let imageURL = artist.images?.first(where: { $0.size == "medium" })?.url {
            RxAlamofire.requestData(.get, imageURL)
                .subscribe(onNext: { [weak self] (response, data) in
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.artistImageView.image = image
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
        
        nameLabel.text = artist.name
        listenersLabel.text = "\(artist.numberOfListeners ?? "0") listeners"
    }
}

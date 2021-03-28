//
//  TopAlbumTableViewCell.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//

import UIKit
import SnapKit
import Kingfisher

class TopAlbumTableViewCell: UITableViewCell, ReuseIdentifiable {
    let albumImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .placeholderText
        iv.kf.indicatorType = .activity
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let playcountLabel: UILabel = {
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
        contentView.addSubview(albumImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(playcountLabel)
        
        albumImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(100).priority(999)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumImageView)
            make.leading.equalTo(albumImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        playcountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    func fill(album: Album) {
        if let imageURL = URL(string: album.images?.first(where: { $0.size == "large" })?.url ?? "") {
            if UserDefaults.standard.bool(forKey: "offline") {
                albumImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"), options: [.onlyFromCache], completionHandler: nil)
            } else {
                albumImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"), options: [.cacheOriginalImage], completionHandler: nil)
            }
        } else {
            albumImageView.image = UIImage(systemName: "photo")
        }
        
        nameLabel.text = album.name
        playcountLabel.text = "\(album.playcount ?? 0) listeners"
    }
}

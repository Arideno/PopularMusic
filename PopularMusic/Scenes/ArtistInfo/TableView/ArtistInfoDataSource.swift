//
//  ArtistInfoDataSource.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 27.03.2021.
//


import UIKit
import RxSwift
import RxDataSources

struct TopAlbumsSection {
    var items: [Album]
}

extension TopAlbumsSection: SectionModelType {
    typealias Item = Album
    
    init(original: TopAlbumsSection, items: [Album]) {
        self = original
        self.items = items
    }
}

class ArtistInfoDataSource: RxTableViewSectionedReloadDataSource<TopAlbumsSection> {
    init() {
        super.init { (dataSource, tableView, indexPath, album) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumTableViewCell.identifier, for: indexPath) as? TopAlbumTableViewCell else { return UITableViewCell() }

            cell.fill(album: album)
            
            return cell
        }
    }
}

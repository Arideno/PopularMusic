//
//  PopularArtistsDataSource.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import UIKit
import RxSwift
import RxDataSources

struct PopularArtistsSection {
    var items: [Artist]
}

extension PopularArtistsSection: SectionModelType {
    typealias Item = Artist
    
    init(original: PopularArtistsSection, items: [Artist]) {
        self = original
        self.items = items
    }
}

class PopularArtistsDataSource: RxTableViewSectionedReloadDataSource<PopularArtistsSection> {
    init() {
        super.init { (dataSource, tableView, indexPath, artist) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularArtistTableViewCell.identifier, for: indexPath) as? PopularArtistTableViewCell else { return UITableViewCell() }

            cell.fill(artist: artist)
            
            return cell
        }
    }
}

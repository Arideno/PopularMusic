//
//  ReuseIdentifiable.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 26.03.2021.
//

import Foundation

protocol ReuseIdentifiable: class {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

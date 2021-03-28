//
//  UIColor+.swift
//  PopularMusic
//
//  Created by  Andrii Moisol on 28.03.2021.
//

import UIKit

extension UIColor {
    
    static let mainColor: UIColor = {
        #if DEBUG
        return UIColor.red
        #else
        return UIColor.blue
        #endif
    }()
    
}

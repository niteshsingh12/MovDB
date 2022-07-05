//
//  UIFont+Extensions.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import UIKit

extension UIFont {
    static var largeCellTitle: UIFont = {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }()
    
    static var cellTitle: UIFont = {
        return UIFont.systemFont(ofSize: 13, weight: .semibold)
    }()
    
    static var cellSubtitle: UIFont = {
        return UIFont.systemFont(ofSize: 10, weight: .light)
    }()
    
    static var detailContent: UIFont = {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }()
    
    static var detailDescription: UIFont = {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }()
    
    static var headerBig: UIFont = {
        return UIFont.systemFont(ofSize: 18, weight: .bold)
    }()
    
    static var detailTitle: UIFont = {
        return UIFont.systemFont(ofSize: 28, weight: .heavy)
    }()
    
    static var detailHeader: UIFont = {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }()
}

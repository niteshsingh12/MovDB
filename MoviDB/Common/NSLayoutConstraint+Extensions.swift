//
//  NSLayoutConstraint+Extensions.swift
//  MoviDB
//
//  Created by Nitesh Singh on 01/07/22.
//

import UIKit

extension NSLayoutConstraint
{
    func withPriority(_ priority: Float) -> NSLayoutConstraint
    {
        self.priority = UILayoutPriority(priority)
        return self
    }
}

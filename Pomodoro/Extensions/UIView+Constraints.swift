//
//  UIView+Constraints.swift
//  Pomodoro
//
//  Created by mac on 20.05.22.
//


import UIKit

extension UIView {
    
    func addSubviewsForAutoLayout(_ views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}


